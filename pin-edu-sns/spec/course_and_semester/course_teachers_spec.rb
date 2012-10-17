require 'spec_helper'

describe CourseTeacher do
  let(:semester_2012_a) { Semester.get(2012, :A) } # 2012年上学期
  let(:semester_2012_b) { Semester.get(2012, :B) } # 2012年下学期

  let(:course_3d)    {FactoryGirl.create :course}
  let(:course_music) {FactoryGirl.create :course}
  let(:course_design) {FactoryGirl.create :course}
  
  let(:teacher_3d) {FactoryGirl.create :user, :teacher}
  let(:teacher_music)  {FactoryGirl.create :user, :teacher}
  let(:teacher_kong)  {FactoryGirl.create :user, :teacher}

  let(:student_song)  {FactoryGirl.create :user, :student}
  let(:student_wu)    {FactoryGirl.create :user, :student}
  let(:student_men)   {FactoryGirl.create :user, :student}
  let(:student_huang) {FactoryGirl.create :user, :student}

  context '学生所选课程的上课时间' do
    before :all do
      course_3d.add_teacher :semester => semester_2012_a,
        :teacher_user => teacher_3d
      course_3d.add_teacher :semester => semester_2012_b,
        :teacher_user => teacher_3d
      
      course_music.add_teacher :semester => semester_2012_a,
        :teacher_user => teacher_music
      course_music.add_teacher :semester => semester_2012_b,
        :teacher_user => teacher_music


      student_song.add_course :semester => semester_2012_a,
        :course       => course_3d,
        :teacher_user => teacher_3d
      student_song.add_course :semester => semester_2012_a,
        :course       => course_music,
        :teacher_user => teacher_music

      student_wu.add_course :semester => semester_2012_a,
        :course       => course_3d,
        :teacher_user => teacher_3d
      student_wu.add_course :semester => semester_2012_a,
        :course       => course_music,
        :teacher_user => teacher_music

      student_men.add_course :semester => semester_2012_b,
        :course       => course_3d,
        :teacher_user => teacher_3d
      student_men.add_course :semester => semester_2012_b,
        :course       => course_music,
        :teacher_user => teacher_music    

      student_huang.add_course :semester => semester_2012_b,
        :course       => course_3d,
        :teacher_user => teacher_3d
      student_huang.add_course :semester => semester_2012_b,
        :course       => course_music,
        :teacher_user => teacher_music    
    end

    it '学生所选的一门课的上课时间查询' do
      time = [
          {:weekday => 1, :number => [2]},
          {:weekday => 4, :number => [3,4]}
      ]

      course_3d.set_course_time :semester => semester_2012_a,
        :teacher_user => teacher_3d,
        :time => time

      value = student_song.get_course_time :semester => semester_2012_a,
        :teacher_user => teacher_3d,
        :course => course_3d

      value.should == {1=>[2],4=>[3,4]}

      time = [
          {:weekday => 2, :number => [3,4]},
          {:weekday => 5, :number => [1]}
      ]

      expect {
        # 尝试给该课程制定上课时间，如果该课程没有制定该老师的课，则抛异常
        course_3d.set_course_time :semester => semester_2012_b,
          :teacher_user => teacher_kong,
          :time => time
      }.to raise_error(Course::InvalidCourseParams)

      expect {
        # 尝试给该课程制定上课时间，如果该学期没有制定该课程，则抛异常
        course_design.set_course_time :semester => semester_2012_b,
          :teacher_user => teacher_kong,
          :time => time
      }.to raise_error(Course::InvalidCourseParams)

      course_3d.set_course_time :semester => semester_2012_b,
        :teacher_user => teacher_3d,
        :time => time

      value = student_men.get_course_time :semester => semester_2012_b,
        :teacher_user => teacher_3d,
        :course => course_3d

      value.should == {2=>[3,4],5=>[1]}
    end



    it '学生所选的所有课程的上课时间查询' do
      time = [
          {:weekday => 1, :number => [2]},
          {:weekday => 4, :number => [3,4]}
      ]

      course_3d.set_course_time :semester => semester_2012_a,
        :teacher_user => teacher_3d,
        :time => time


      time = [
          {:weekday => 2, :number => [5,6]},
          {:weekday => 5, :number => [1]}
      ]

      course_music.set_course_time :semester => semester_2012_a,
        :teacher_user => teacher_music,
        :time => time

      should_value = {
        course_music.name => {2=>[5,6],5=>[1]},
        course_3d.name    => {1=>[2],4=>[3,4]}
      }

      value = student_song.get_all_course_time(:semester => semester_2012_a)

      value.should == should_value
    end

  end

  context "一门课程在哪些学期分布" do
    it '一门课程在哪些学期分布' do
      course_3d.get_semesters().should == []

      course_3d.add_teacher :semester => semester_2012_a,
        :teacher_user => teacher_3d
      course_3d.get_semesters().should == [semester_2012_a]

      course_3d.add_teacher :semester => semester_2012_b,
        :teacher_user => teacher_3d
      semesters = course_3d.get_semesters()
      semesters.length.should == 2
      semesters.include?(semester_2012_a).should == true
      semesters.include?(semester_2012_b).should == true
    end
  end

  context '学期下有任课教师的课程' do
    it '学期下有任课教师的课程' do
      semester_2013_a = Semester.get_by_value("2013A")
      semester_2013_a.get_courses.should == []

      course_3d.add_teacher :semester => semester_2013_a,
        :teacher_user => teacher_3d
      semester_2013_a.get_courses.should == [course_3d]

      course_music.add_teacher :semester => semester_2013_a,
        :teacher_user => teacher_music
      semester_2013_a.get_courses.length.should == 2
      semester_2013_a.get_courses.include?(course_music)
      semester_2013_a.get_courses.include?(course_3d)

      course_3d.add_teacher :semester => semester_2013_a,
        :teacher_user => teacher_music
      semester_2013_a.get_courses.length.should == 2
      semester_2013_a.get_courses.include?(course_music)
      semester_2013_a.get_courses.include?(course_3d)
    end
  end
end