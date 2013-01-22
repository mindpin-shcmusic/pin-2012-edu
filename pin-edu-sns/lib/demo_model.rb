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

  # -----------------------------------

  DemoResourceNames = ['面向对象程序设计.ppt', '数组与字符串.ppt']

  DemoResources = DemoResourceNames.map do |name|
    OpenStruct.new(:name       => name,
                   :created_at => 4.days.ago,
                   :is_dir     => false,
                   :id         => DemoResourceNames.index(name) + 1,
                   :path       => 'javascript:;',
                   :pages      => ['/assets/demo_ppt/page1.png'])
  end

  # --------- question ---------------
  class Question
    attr_accessor :title, :desc, :answers, :creator, :comments, :best_answer
  end

  class Answer
    attr_accessor :content, :attachment, :creator, :comments
  end

  class Comment
    attr_accessor :content, :creator
  end

  zhaoyun = User.find_by_name("zhaoyun")
  guanyu = User.find_by_name("guanyu")
  zhugeliang = User.find_by_name('zhugeliang')

  question_1 = Question.new
  question_1.title = "java如不想么每次都判空 if(o !=null) 怎么做？"
  question_1.desc = "代码中好多这种代码，看起来好混乱，但是又不知道怎么去精简掉"
  question_1.creator = zhaoyun

  answer_1_1 = Answer.new
  answer_1_1.content = "建议使用NullObject模式。"
  answer_1_1.creator = zhugeliang

  question_2 = Question.new
  question_2.title = "Java里ClassName.this和this有什么不一样"
  question_2.desc = ""
  question_2.creator = zhaoyun
  question_2.comments = []
  question_2.answers = []

  question_3 = Question.new
  question_3.title = "有Java的布隆过滤器实现吗？"
  question_3.desc = ""
  question_3.creator = zhaoyun
  question_3.comments = []
  question_3.answers = []

  question_4 = Question.new
  question_4.title = "Integer和int有什么不同？"
  question_4.desc = ""
  question_4.creator = zhaoyun
  question_4.comments = []
  question_4.answers = []

  question_5 = Question.new
  question_5.title = "Java参数向量argv问题"
  question_5.desc = ""
  question_5.creator = zhaoyun
  question_5.comments = []
  question_5.answers = []

  question_6 = Question.new
  question_6.title = "java内部是如何处理判断一个对象是否被实例化的？"
  question_6.desc = ""
  question_6.creator = guanyu
  question_6.comments = []
  question_6.answers = []

  question_7 = Question.new
  question_7.title = "Java中的接口有什么作用？"
  question_7.desc = ""
  question_7.creator = guanyu
  question_7.comments = []
  question_7.answers = []

  question_8 = Question.new
  question_8.title = "什么是对象持久化，与数据序列化有何联系？"
  question_8.desc = ""
  question_8.creator = guanyu
  question_8.comments = []
  question_8.answers = []

  question_9 = Question.new
  question_9.title = "java如何用byte[]构造BufferedImage,处理之后怎么再输出为byte[]?"
  question_9.desc = ""
  question_9.creator = guanyu
  question_9.comments = []
  question_9.answers = []

  question_10 = Question.new
  question_10.title = "关于电梯算法"
  question_10.desc = ""
  question_10.creator = guanyu
  question_10.comments = []
  question_10.answers = []

  TEACHER_QUESTIONS = [
    question_1,
    question_2,
    question_3,
    question_4,
    question_5,
    question_6,
    question_7,
    question_8,
    question_9,
    question_10
  ]

  STUDENT_QUESTIONS = [
    question_1,
    question_2,
    question_3,
    question_4,
    question_5
  ]
  
end