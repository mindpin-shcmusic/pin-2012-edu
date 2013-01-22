module DemoModel
  class TeachingPlan
    attr_accessor :title, :desc
  end

  TEACHING_PLAN_1 = TeachingPlan.new
  TEACHING_PLAN_1.title = 'Java程序设计'
  TEACHING_PLAN_1.desc = '给没有编程基础的初学者准备的JAVA入门教学方案，通过这个方案的学习，让学生掌握JAVA的基本语法，调试方法，基本类库的使用。并且能够开发简单的应用程序。'

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
  KEJIAN_2.filename = '深入生活的JAVA语言.ppt'

  KEJIAN_3 = Kejian.new
  KEJIAN_3.title = '课件标题'
  KEJIAN_3.desc = '课件描述'

  CHAPTER_1_KEJIANS = [KEJIAN_1, KEJIAN_2, KEJIAN_3]
end