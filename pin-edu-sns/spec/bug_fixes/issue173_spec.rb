# -*- coding: no-conversion -*-
require 'spec_helper'

describe 'issue173' do
  before do
    @team_1 = Team.new( :name => '三年二班', :cid => 'team_01' )
    @team_1.save.should == true

    @team_2 = Team.new( :name => '四年三班', :cid => 'team_02' )
    @team_2.save.should == true

    @user_1 = User.new(:email=>"fushang318@gmail.com",:name=>'fushang318',:password=>"123456",:password_confirmation=>"123456")
    @user_1.save.should == true
      
    @student_1 = Student.new(
      :real_name => '李飞',
      :sid => 'lifei_01',
      :user_id => @user_1.id
    )

    @student_1.save.should == true
  end


  it '班级被删除后，该班级内的学生应该变为无班级状态' do
    Student.no_team.should == [@student_1]

    @team_1.student_user_ids = [@user_1.id]
    @team_1 = Team.find(@team_1.id)
    @team_1.student_users.include?(@user_1).should == true

    Student.of_team(@team_1).should == [@student_1]
    Student.no_team.should == []    
    @team_1.remove

    Student.no_team.should == [@student_1]    
  end

  it '一个学生不应该同时属于两个班级' do
    Student.no_team.should == [@student_1]
    @team_1.student_user_ids = [@user_1.id]
    Student.of_team(@team_1).should == [@student_1]
    Student.no_team.should == []

     expect {
        @team_2.student_user_ids = [@user_1.id]
      }.to raise_error(ActiveRecord::RecordInvalid)

    Student.no_team.should == []
    Student.of_team(@team_2).should == []
  end
end