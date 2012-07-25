require 'spec_helper'

describe MediaShareRule do
  let(:rule)     {MediaShareRule.new}
  let(:input)    {{:users => [1, 2, 3, 4]}}
  let(:expected) {input.merge({:teams   => [],
                               :courses => []})}

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

  context 'courses and teams user ids fetchers' do
    [:course, :team].each do |sym|
      let(sym)                {send(:"make_a_#{sym}", 4)}
      let(:"#{sym}_users")    {send(sym).get_users}
      let(:"#{sym}_user_ids") {send(sym).get_user_ids}

      let(:"#{sym}_resource") {FactoryGirl.create :media_resource,
                                                  :creator => send(sym).teacher.user}

      let(:"#{sym}_rule")     {FactoryGirl.build :media_share_rule,
                                                 :media_resource => send(:"#{sym}_resource"),
                                                 :creator        => send(sym).teacher.user}
    end

    # before do
    #   users    = 1.upto(4).map {FactoryGirl.create(:user)}
    #   @teacher  = FactoryGirl.create(:teacher, :user => users[3] )
    #   @students = users[0, 3].map {|user| FactoryGirl.create(:student, :user => user)}
    #   @user_ids = users.map(&:id)
    #   resource  = FactoryGirl.create :media_resource,
    #                                  :creator => @teacher.user

    #   @rule     = FactoryGirl.build :media_share_rule,
    #                                 :media_resource => resource,
    #                                 :creator        => @teacher.user
    # end

    describe '#courses_or_teams_receiver_ids' do
      [Team, Course].each do |model|
        it 'should return all participating users\' ids' do
          # org = FactoryGirl.create(:"#{model.to_s.underscore}", :teacher => @teacher)
          # org.students = @students
          
          # @rule.build_expression(:"#{model.to_s.tableize}" => [model.first.id])

          model_name = model.to_s.underscore
          rule = send(:"#{model_name}_rule")
          [rule.expression, rule.deleting].each do |action|
            rule.send(:courses_or_teams_receiver_ids, action, model).should eq send("#{model_name}_user_ids")
          end

        end
        
      end

    end

    describe '#receiver_ids' do
      it 'should return all recipent ids' do
        # course = FactoryGirl.create(:course, :teacher => @teacher)
        # course.students = @students
      
        # team = FactoryGirl.create(:team, :teacher => @teacher)
        # team.students = @students


        # @rule.build_expression(:users   => @user_ids,
        #                        :teams   => [Team.first.id],
        #                        :courses => [Course.first.id])

        recipent_ids = @user_ids[0, 3]

        [@rule.expression, @rule.deleting].each do |action|
          @rule.send(:receiver_ids, action).should eq recipent_ids.sort
        end
      end
    end

  end

  context 'private after_save callbacks' do
    before do
      @user = FactoryGirl.create :user
      resource = FactoryGirl.create :media_resource, :creator => @user
    end

    describe '#update_achievement' do
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
    
    describe '#enqueue_build_share' do
      it 'should queue the build share job' do
        rule = FactoryGirl.build(:media_share_rule, :creator => @user)
        BuildMediaShareResqueQueue.should_receive(:enqueue).with(an_instance_of(Fixnum))
        rule.save
      end
    end

  end

end
