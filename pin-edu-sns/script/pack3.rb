# -*- coding: utf-8 -*-
def pack3_1
  names = ['作曲', '编曲', '混音', '声乐']

  ActiveRecord::Base.transaction do

    homeworks = Homework.where('title like "课程实践作业%"')

    homeworks.each do |homework|
      homework.homework_assign_rule.delete
      homework.homework_assigns.destroy_all
      homework.homework_requirements.delete_all
    end

    homeworks.delete_all

    Teacher.all.map(&:user).each do |teacher_user|
      courses = teacher_user.get_teacher_courses(:semester => Semester.get(2012, :B))

      courses.each do |course|
        name = names[rand 4]

        homework = Homework.create(:title    => "课程实践作业#{name} - #{course.name}",
                                   :content  => "进行#{name}练习。",
                                   :course   => course,
                                   :deadline => [4, 5, 6][rand 3].days.from_now,
                                   :creator  => teacher_user,
                                   :kind     => Homework::KINDS[rand 2])

        HomeworkRequirement.create :title => name, :homework => homework
        homework.assign_to({:courses => [course.id]})
        homework.homework_assign_rule.build_assign
      end

    end

  end

end

def pack3_2
  ActiveRecord::Base.transaction do
    Question.where('title like "%这门课%"').destroy_all

    p "每个学生向自己所在课程的老师提出的一个问题"
    # 每个学生向自己所在课程的老师提出的一个问题
    assigns = CourseStudentAssign.all
    length = assigns.length
    assigns.each_with_index do |assign,index|
      p "#{index+1}/#{length}"
      student_user = assign.student_user
      teacher_user = assign.teacher_user
      course_name = assign.course.name
      case index % 3
      when 0
        title = "#{teacher_user.real_name}老师，#{course_name} 这门课有哪些学习要点？"
        content = "RT"
      when 1
        title = "#{teacher_user.real_name}老师，#{course_name} 这门课需要哪些前置课程？"
        content = "RT"
      when 2
        title = "#{teacher_user.real_name}老师，#{course_name} 这门课学完后对做什么事情有帮助？"
        content = "RT"
      end
      student_user.questions.create!(:title => title,
                                     :content => content,
                                     :teacher_user_id => teacher_user.id)
    end
  end
end

def pack3_3
  ActiveRecord::Base.transaction do
    announcements = Announcement.where('title like "[dev通知]%"')
    announcements.each do |a|
      a.announcement_rule
      a.announcement_users.destroy_all
    end
    announcements.destroy_all

    admin = User.find_by_name('admin')
    p "教学管理员发给所有老师的两条通知"
    # 教学管理员发给所有老师的两条通知
    announcement1 = admin.created_announcements.create!(:title => "[dev通知]11 月 3 号到教务处开会",
                                                        :content => "讨论关于最近学校发生的几起打架事件如何处理")
    announcement2 = admin.created_announcements.create!(:title => "[dev通知]11 月 5 号到教务处开会",
                                                        :content => "讨论这个学期整体的教学安排")
    announcement1.announce_to(:all_teachers => true)
    announcement1.announcement_rule.build_announcement
    announcement2.announce_to(:all_teachers => true)
    announcement2.announcement_rule.build_announcement
    p "教学管理员发给所有学生的两条通知"
    # 教学管理员发给所有学生的两条通知
    announcement3 = admin.created_announcements.create!(:title => "关于最近学校发生的几起打架事件",
                                                        :content => "希望大家不要因为一点小矛盾就大打出手，有则改之，无则加勉，希望大家互相监督")
    announcement4 = admin.created_announcements.create!(:title => "关于最近大家对课程安排的问题，可以发送邮件到教务处邮箱",
                                                        :content => "希望大家有什么问题，直接反馈给教务处，校方希望给大家提供更好的教学")
    announcement3.announce_to(:all_students => true)
    announcement3.announcement_rule.build_announcement
    announcement4.announce_to(:all_students => true)
    announcement4.announcement_rule.build_announcement

    Teacher.all.each do |teacher|
      a = Announcement.create(:creator => teacher.user, 
                              :title => "[dev通知]毕业论文通知 - #{teacher.real_name}",
                              :content => "#{teacher.real_name} 给同学们介绍论文相关情况")

      a.announce_to :courses => a.creator.get_teacher_courses(:semester => Semester.now).map(&:id)

      a.announcement_rule.build_announcement
    end
  end
end

def pack3
  depends_on [1, 2]
  pack3_1
  pack3_2
  pack3_3
  touch_pack_record(3)
end
