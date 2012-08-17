# -*- coding: utf-8 -*-
homework_data1 = ['今天没作业呀！', '谁写作业谁二啊！', 1.month.from_now]
homework_data2 = ['写篇作文吧', '只要有字就行啊！', 2.weeks.from_now]
homework_data3 = ['少年你不想写作业么？', '别做梦了，好好学习吧。', 1.week.ago]
homework_data4 = ['熬夜去吧', '两点半之后不睡觉准有好事。', 4.minute.from_now]
HOMEWORKS_DATA = [homework_data1, homework_data2, homework_data3, homework_data4]
TEACHERS       = Teacher.find(:all, :limit => 4)

ActiveRecord::Base.transaction do 
  (0...4).each {|i|
    puts "创建作业-#{i}"
    homework_data = HOMEWORKS_DATA[i]
    teacher_user  = TEACHERS[i].user
    course        = teacher_user.courses[0]
    team          = teacher_user.teams

    homework = Homework.create(:title        => homework_data[0],
                               :content      => homework_data[1],
                               :course       => course,
                               :deadline     => homework_data[2],
                               :creator      => teacher_user)

    homework.assign_to({:teams => teacher_user.teams.map(&:id)})

  }
end
