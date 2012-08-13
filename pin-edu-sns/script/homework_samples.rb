# -*- coding: utf-8 -*-
homework1 = ['今天没作业呀！', '谁写作业谁二啊！', 1.month.from_now]
homework2 = ['写篇作文吧', '只要有字就行啊！', 2.weeks.from_now]
homework3 = ['少年你不想写作业么？', '别做梦了，好好学习吧。', 1.week.ago]
homework4 = ['熬夜去吧', '两点半之后不睡觉准有好事。', 2.minute.from_now]
COURSES = Course.all.shuffle

[homework1, homework2, homework3, homework4].each {|hw|
  Homework.create :title    => hw[0],
                  :content  => hw[1],
                  :course   => COURSES[rand COURSES.count - 1],
                  :deadline => hw[2]
}
