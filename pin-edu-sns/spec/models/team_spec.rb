require 'spec_helper'

describe Team do
  describe '#get_users' do
    subject {Team}
    it "should return all participating users" do
      users    = 1.upto(4).map {FactoryGirl.create(:user)}
      teacher  = FactoryGirl.create(:teacher, :user => users[3] )
      team     = FactoryGirl.create(:team, :teacher => teacher)
      team.students = users[0, 3].map {|user| FactoryGirl.create(:student, :user => user)}

      team.get_users.should eq users
    end
  end
end