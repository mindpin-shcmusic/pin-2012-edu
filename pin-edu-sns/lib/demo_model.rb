module DemoModel
  class TeachingPlan
    attr_accessor :title, :desc
  end

  TEACHING_PLAN_1 = TeachingPlan.new
  TEACHING_PLAN_1.title = 'Java程序设计教学方案'
  TEACHING_PLAN_1.desc = '给没有编程基础的初学者准备的JAVA入门教学方案，通过这个方案的学习，让学生掌握JAVA的基本语法，调试方法，基本类库的使用。并且能够开发简单的应用程序。'
end