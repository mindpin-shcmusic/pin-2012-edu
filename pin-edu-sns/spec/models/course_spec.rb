require 'spec_helper'

describe Course do
  describe '#get_users' do
    subject {Course}
    it 'should return all participating users' do
      users    = 1.upto(4).map {FactoryGirl.create(:user)}
      teacher  = FactoryGirl.create(:teacher, :user => users[3] )
      course   = FactoryGirl.create(:course, :teacher => teacher)
      course.students = users[0, 3].map {|user| FactoryGirl.create(:student, :user => user)}

      course.get_users.should eq users
    end
  end
end
