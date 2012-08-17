# -*- coding: utf-8 -*-
homework_data1 = ['作业1', '画一幅画。', 1.month.from_now]
homework_data2 = ['作业2', '编一首曲子。', 2.weeks.from_now]
homework_data3 = ['作业3', '写一篇论文。', 1.week.ago]
homework_data4 = ['作业4', '剪辑一段视频。', 4.minute.from_now]
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

    homework.homework_assign_rule.build_assign
  }
end
