# -*- coding: utf-8 -*-
require 'pp'
course_expressions = [
 {:name=>"思想道德修养与法律基础",
  :teacher=>"黄静",
  :location=>"北418",
  :time_expression=>[{:weekday=>2, :number=>[1]}]},
 {:name=>"中国近现代史纲要",
  :teacher=>"黄静",
  :location=>"北418",
  :time_expression=>[{:weekday=>2, :number=>[2]}]},
 {:name=>"大学语文",
  :teacher=>"杨赛",
  :location=>"北606",
  :time_expression=>[{:weekday=>2, :number=>[7, 8]}]},
 {:name=>"英语",
  :teacher=>"详见英语分班表",
  :location=>"详见英语分班表",
  :time_expression=>
   [{:weekday=>2, :number=>[9, 10]}, {:weekday=>5, :number=>[9, 10]}]},
 {:name=>"体育（男）",
  :teacher=>"张锷、方正基、刘玮",
  :location=>"操场",
  :time_expression=>[{:weekday=>5, :number=>[7, 8]}]},
 {:name=>"体育（女）",
  :teacher=>"王梦、关虹",
  :location=>"操场",
  :time_expression=>[{:weekday=>3, :number=>[7, 8]}]},
 {:name=>"音乐基础理论",
  :teacher=>"戴维一",
  :location=>"中607",
  :time_expression=>[{:weekday=>1, :number=>[3, 4]}]},
 {:name=>"绘画基础A",
  :teacher=>"秦奕",
  :location=>"北219",
  :time_expression=>[{:weekday=>1, :number=>[7, 8, 9, 10]}]},
 {:name=>"绘画基础B",
  :teacher=>"秦奕",
  :location=>"北219",
  :time_expression=>[{:weekday=>1, :number=>[11, 12]}]},
 {:name=>"程序语言",
  :teacher=>"陈世哲",
  :location=>"北604",
  :time_expression=>[{:weekday=>3, :number=>[3, 4]}]},
 {:name=>"数字媒体表现艺术",
  :teacher=>"秦奕",
  :location=>"北604",
  :time_expression=>[{:weekday=>4, :number=>[1, 2, 3, 4]}]},
 {:name=>"动画基础",
  :teacher=>"秦奕",
  :location=>"北604",
  :time_expression=>[{:weekday=>4, :number=>[7, 8]}]},
 {:name=>"日语会话A",
  :teacher=>"张治军",
  :location=>"中215",
  :time_expression=>[{:weekday=>2, :number=>[3, 4]}]},
 {:name=>"日语会话B",
  :teacher=>"张治军",
  :location=>"中215",
  :time_expression=>[{:weekday=>2, :number=>[5, 6]}]}]

semester = Semester.get(2012, :B)

ActiveRecord::Base.transaction do
  course_expressions.reduce(1) do |id, expression|
    teacher = Teacher.find_or_initialize_by_real_name expression[:teacher]
    if !teacher.persisted?
      teacher.tid = "tid-n#{id}"
      teacher.user = User.create(:name => "teachern#{id}",
                                 :password => '1234',
                                 :email => "#{teacher.tid}@edu.dev")
      teacher.save
    end

    course = Course.find_or_initialize_by_name(expression[:name])
    if !course.persisted?
      course.cid = "cid-n#{id}"
      course.save
    end

    course_teacher = CourseTeacher.find_or_initialize_by_teacher_user_id_and_course_id(teacher.user_id, course.id)
    if !course_teacher.persisted? || course_teacher.time_expression.blank?
      course.add_teacher(:semester => semester,
                         :teacher_user => teacher.user)

      course.set_course_time(:semester => semester,
                             :teacher_user => teacher.user,
                             :time => expression[:time_expression])

    end

    id + 1
  end
end
