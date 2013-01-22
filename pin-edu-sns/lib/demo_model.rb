module DemoModel
  class TeachingPlan
    attr_accessor :title, :desc, :chapters, :creator, :progress

    def add_chapter(chapter)
      self.chapters||=[]
      self.chapters << chapter
    end
  end

  class Chapter
    attr_accessor :title, :desc, :homeworks
    def add_homework(homework)
      self.homeworks||=[]
      self.homeworks << homework
    end
  end

  class Homework
    attr_accessor :title, :desc, :creator, :requirements,
      :created_at, :deadline, :attachments, :student_users
  end

  TEACHING_PLAN_1 = TeachingPlan.new
  TEACHING_PLAN_1.title = 'Java程序设计'
  TEACHING_PLAN_1.desc = '给没有编程基础的初学者准备的JAVA入门教学方案，通过这个方案的学习，让学生掌握JAVA的基本语法，调试方法，基本类库的使用。并且能够开发简单的应用程序。'
  TEACHING_PLAN_1.creator = User.find_by_name('zhugeliang')
  TEACHING_PLAN_1.progress = "46%"

  TEACHING_PLAN_2 = TeachingPlan.new
  TEACHING_PLAN_2.title = "Android开发课程教学方案"
  TEACHING_PLAN_2.desc = "给有一定Java基础的学生准备的教学方案，通过这个方案的学习，让学生学会搭建Andorid开发环境，熟悉SDK，会做一些简单的Android应用"
  TEACHING_PLAN_2.creator = User.find_by_name('zhugeliang')
  TEACHING_PLAN_2.progress = "0%"

  TEACHING_PLAN_3 = TeachingPlan.new
  TEACHING_PLAN_3.title = "JavaScript开发教学方案"
  TEACHING_PLAN_3.desc = "给有一定HTML基础的学生准备的教学方案，通过这个方案的学习，让学生可以在HTML静态页面的基础上做一些更复杂交互的页面"
  TEACHING_PLAN_3.creator = User.find_by_name('zhugeliang')
  TEACHING_PLAN_3.progress = "16%"
  TEACHING_PLANS = [TEACHING_PLAN_1,TEACHING_PLAN_2,TEACHING_PLAN_3]


  chapter_1 = Chapter.new
  chapter_1.title = "面向对象程序设计"
  chapter_1.desc = "详细介绍面向对象设计到得各种概念"
  TEACHING_PLAN_1.add_chapter(chapter_1)

  chapter_2 = Chapter.new
  chapter_2.title = "数组与字符串"
  chapter_2.desc = "讲解JAVA中的数组与字符串"
  chapter_2.homeworks = []
  TEACHING_PLAN_1.add_chapter(chapter_2)

  chapter_3 = Chapter.new
  chapter_3.title = "常用Java系统类和接口"
  chapter_3.desc = "详细讲解JAVA中常用的一些API"
  chapter_3.homeworks = []
  TEACHING_PLAN_1.add_chapter(chapter_3)


  homework = Homework.new
  homework.title = "类和对象的基本概念"
  homework.desc = "完成课后习题,试着用形象的语言来描述自己对类和对象的理解"
  homework.creator = User.find_by_name("zhugeliang")
  homework.created_at = Time.now-3.second
  homework.deadline = Time.now+1.day
  homework.attachments = ["作业习题.doc"]
  homework.requirements = ["作业的源代码","作业遇到的问题","参考的书籍列表"]
  student_names = "关平,关彝,张嶷,周仓,魏延,关索,关统,夏侯霸,关兴,赵云,黄月英,张飞,关羽,王平,黄盖,张翼,黄崇,吕凯,黄忠,黄承彦,张苞,姜维"
  homework.student_users = student_names.split(',').map{|name|Student.find_by_real_name(name).user}

  chapter_1.add_homework(homework)


  homework_2 = Homework.new
  homework_2.title = "面向对象程序设计基本思想"
  homework_2.desc = "完成课后习题"
  homework_2.requirements = [1,2,3,4]
  chapter_1.add_homework(homework_2)

  homework_3 = Homework.new
  homework_3.title = "类的设计"
  homework_3.desc = "完成课后习题"
  homework_3.requirements = [1,2,3,4]
  chapter_1.add_homework(homework_3)

  # --------------------------------------------------

  class Kejian
    attr_accessor :title, :desc, :filename
  end

  KEJIAN_1 = Kejian.new
  KEJIAN_1.title = 'JAVA语言的基本概念'
  KEJIAN_1.desc = '介绍JAVA语言的一些基本概念和用途'
  KEJIAN_1.filename = 'JAVA语言的基本概念.ppt'

  KEJIAN_2 = Kejian.new
  KEJIAN_2.title = '深入生活的JAVA语言'
  KEJIAN_2.desc = '展示JAVA语言与我们日常生活，互联网，手机应用的密切关系'
  KEJIAN_2.filename = '深入生活的JAVA语言.avi'

  KEJIAN_3 = Kejian.new
  KEJIAN_3.title = '课件标题'
  KEJIAN_3.desc = '课件描述'

  CHAPTER_1_KEJIANS = [KEJIAN_1, KEJIAN_2, KEJIAN_3]

end