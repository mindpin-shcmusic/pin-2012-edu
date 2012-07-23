require 'spec_helper'

describe MediaShareRule do
  let(:rule)     {MediaShareRule.new}
  let(:input)    {{:users => [1, 2, 3, 4]}}
  let(:expected) {input.merge({:teams => [], :courses => []})}

  context 'expression setter and getter' do
    subject {rule}

    describe '#build_expression' do
      subject {rule.build_expression(input)}
      it {should eq expected.to_json}
    end

    describe '#expression' do
      before {rule.build_expression(input)}
      its(:expression) {should eq expected}
    end
  end

  describe '#get_courses_receiver_ids' do
    it 'should return all participating users\' ids' do
      users    = 1.upto(4).map {FactoryGirl.create(:user)}
      teacher  = FactoryGirl.create(:teacher, :user => users[3] )
      course   = FactoryGirl.create(:course, :teacher => teacher)
      course.students = users[0, 3].map {|user| FactoryGirl.create(:student, :user => user)}
      user_ids = users.map(&:id)
      
      resource = FactoryGirl.create :media_resource,
                                    :creator => teacher.user

      rule     = FactoryGirl.build :media_share_rule,
                                   :media_resource => resource,
                                   :creator => teacher.user
      rule.build_expression(:courses => [Course.first.id])

      rule.get_courses_receiver_ids.should eq user_ids.sort
    end
  end

  describe '#get_teams_receiver_ids' do
    it 'should return all participating users\' ids' do
      users    = 1.upto(4).map {FactoryGirl.create(:user)}
      teacher  = FactoryGirl.create(:teacher, :user => users[3] )
      team     = FactoryGirl.create(:team, :teacher => teacher)
      team.students = users[0, 3].map {|user| FactoryGirl.create(:student, :user => user)}
      user_ids = users.map(&:id)
      
      resource = FactoryGirl.create :media_resource,
                                    :creator => teacher.user

      rule     = FactoryGirl.build :media_share_rule,
                                   :media_resource => resource,
                                   :creator => teacher.user
      rule.build_expression(:teams => [Team.first.id])

      rule.get_teams_receiver_ids.should eq user_ids.sort
    end
  end

  describe '#update_achievement' do
    before do
      @user = FactoryGirl.create :user
      resource = FactoryGirl.create :media_resource, :creator => @user
    end

    it 'should updates user achievement' do
      Achievement.first.should be nil
      FactoryGirl.create :media_share_rule, :creator => @user
      Achievement.first.share_rate.should eq User.first.share_rate
    end

    it 'should notify user' do
      rule = FactoryGirl.build :media_share_rule, :creator => @user
      UserShareRateTipMessage.should_receive(:notify_share_rank).with(User.first)
      rule.save
    end
  end


  describe '#enqueue_build_share'
end
