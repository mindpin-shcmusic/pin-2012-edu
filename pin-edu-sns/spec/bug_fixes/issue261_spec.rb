# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'issue261' do
  let(:team) {FactoryGirl.create :team, :with_student_users}
  let(:homework) {FactoryGirl.create(:homework)}
  let(:student_user) {team.student_users.first}

  before(:all) do
    homework.assign_to :teams => [team.id]
    homework.homework_assign_rule.build_assign
  end

  it '如果删除学生B，老师在查看作业状况时不应该再出现学生B' do
    homework.assignees.should include student_user
    student_user.student.destroy
    homework.assignees.reload.should_not include student_user
  end
end
