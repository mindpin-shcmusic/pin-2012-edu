# -*- coding: no-conversion -*-
require 'spec_helper'

describe 'issue262' do
  let(:team) {FactoryGirl.create :team, :with_student_users}
  let(:student_user) {team.student_users.first}

  it '如果删除学生A，在B班级页面不应该再出现学生A' do
    team.student_users.should include student_user
    student_user.student.remove
    team.student_users.reload.should_not include student_user
  end
end
