# -*- coding: utf-8 -*-
require 'spec_helper'

describe '老师分配作业给学生B所在班级后B学生被管理员删除，查看作业状况时不应该再出现B学生' do
  before {
    homework = FactoryGirl.create(:homework)
    homework.assign_to
  }
end
