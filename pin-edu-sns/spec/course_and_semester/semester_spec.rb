require 'spec_helper'



describe Course do
  describe '课程是客观存在的对象，和学期，教师，学生，均没有由它们带来的约束关系' do
  end

  let(:teacher_zhang) {FactoryGirl.create :user, :teacher}
  let(:teacher_wang)  {FactoryGirl.create :user, :teacher}
  let(:teacher_li)    {FactoryGirl.create :user, :teacher}
  let(:teacher_zhao)  {FactoryGirl.create :user, :teacher}

  let(:student_song)  {FactoryGirl.create :user, :student}
  let(:student_wu)    {FactoryGirl.create :user, :student}
  let(:student_men)   {FactoryGirl.create :user, :student}
  let(:student_huang) {FactoryGirl.create :user, :student}

  let(:course_3d)    {FactoryGirl.create :course}
  let(:course_music) {FactoryGirl.create :course}

  let(:semester_2012_a) { Semester.get(2012, :A) } # 2012年上学期
  let(:semester_2012_b) { Semester.get(2012, :B) } # 2012年下学期

  it '系统能够使用学期抽象类获得学期值' do
    # 学期值是一个特定表达方法的值，并非一个数据库表，也并非一个ActiveRecord对象
    # Semester是用来维护，管理和获取这个值的一个抽象类

    semester_2012_a = Semester.get(2012, :A) # 2012年上学期
    semester_2012_b = Semester.get(2012, :B) # 2012年下学期

    semester_2012_a.value.should == '2012A'
    semester_2012_b.value.should == '2012B'

    s1 = Semester.of_time Time.mktime(2012, 10)
    s1.value.should == '2012B'
    s1.should == semester_2012_b

    s2 = Semester.of_time Time.mktime(2013, 4)
    s2.value.should == '2013A'

    Semester.now.should == Semester.of_time(Time.now)
  end

  it '能够在一个学期的某个课程下添加多个任课老师，并且能够取得指定的不同学期的课程下面的任课老师' do
    course_3d.add_teacher :semester     => semester_2012_a,
                          :teacher_user => teacher_zhang

    course_3d.add_teacher :semester     => semester_2012_a,
                          :teacher_user => teacher_wang

    course_3d.add_teacher :semester     => semester_2012_b,
                          :teacher_user => teacher_li

    course_3d.add_teacher :semester     => semester_2012_b,
                          :teacher_user => teacher_zhao

    expect {
      # 参数未指定学期，老师，则抛异常
      course_3d.add_teacher({})
    }.to raise_error(Course::InvalidCourseParams)

    teachers_2012_a = course_3d.get_teachers(:semester => semester_2012_a)
    teachers_2012_a.length.should == 2
    teachers_2012_a.include?(teacher_zhang).should == true
    teachers_2012_a.include?(teacher_wang).should == true

    teachers_2012_b = course_3d.get_teachers(:semester => semester_2012_b)
    teachers_2012_b.length.should == 2
    teachers_2012_b.include?(teacher_li).should == true
    teachers_2012_b.include?(teacher_zhao).should == true
  end

  it '能够在指定的学期下，给一个学生指定他要上的课，以及指定任课老师' do
    course_3d.add_teacher :semester     => semester_2012_a,
                          :teacher_user => teacher_zhang

    course_3d.add_teacher :semester     => semester_2012_a,
                          :teacher_user => teacher_wang

    student_song.add_course :semester     => semester_2012_a,
                            :course       => course_3d,
                            :teacher_user => teacher_zhang

    expect {
      # 尝试给学生增加课程，但是该学期该课程下并不存在该老师，则抛异常
      student_song.add_course :semester     => semester_2012_a,
                              :course       => course_3d,
                              :teacher_user => teacher_li
    }.to raise_error(Course::InvalidCourseParams)

    # 获取某个学生在某个学期要上的课
    courses = student_song.get_courses :semester => semester_2012_a
    courses.length.should == 1
    courses[0].should == course_3d

    course_music.add_teacher :semester => semester_2012_a,
                             :teacher  => teacher_li

    student_song.add_course :semester => semester_2012_a,
                            :course   => course_music,
                            :teacher  => teacher_li

    # 获取某个学生在某个学期的所有任课老师
    teachers = student_song.get_teachers :semester => semester_2012_a
    teachers.length.should == 2
    teachers.include?(teacher_zhang).should == true
    teachers.include?(teacher_li).should == true
  end

  pending '课程能够归属到一个或多个教学计划'
  pending '能够根据教学计划，查找这个教学计划中包含的课程'
  pending '学生能够归属到一个教学计划'
  pending '学生能够在教学计划所包含的课程的范围中指定其要上的课'

  pending '能够在不同的学期给一个班的学生指定要上的课，但是产生的指定记录仍然直接指向学生'
end