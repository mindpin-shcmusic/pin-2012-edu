# -*- coding: utf-8 -*-
require 'spec_helper'

describe CourseStudentScore do
  let(:semester_2012_b) {Semester.get(2012, :B)} # 2012年下学期
  let(:course_3d)     {FactoryGirl.create :course}
  let(:teacher_3d)    {FactoryGirl.create :user, :teacher}
  let(:student_song)  {FactoryGirl.create :user, :student}
  let(:options)       {{:course => course_3d, :student_user => student_song, :semester => semester_2012_b}}

  context '老师可以给对应学期自己负责的课程下的学生创建分数表记录' do
    before(:all) do
      course_3d.add_teacher(:semester     => semester_2012_b,
                            :teacher_user => teacher_3d)

      student_song.add_course(:semester     => semester_2012_b,
                              :course       => course_3d,
                              :teacher_user => teacher_3d)
    end

    it '老师创建分数表记录' do
      options.each_key do |key|
        options_dup = options.dup
        options_dup.delete key

        expect {
          teacher_3d.create_course_score(options_dup)
        }.to raise_error(Course::InvalidCourseParams)
      end

      record = teacher_3d.create_course_score(options)

      record.teacher_user.should eq teacher_3d
      record.student_user.should eq student_song
      record.semester.should eq semester_2012_b
    end

  end

end
