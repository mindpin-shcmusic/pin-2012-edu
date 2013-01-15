# -*- coding: utf-8 -*-
class DemoQuestion
  attr_accessor :title, :teacher_user, :creator, :has_answered
end

DemoQuestionTitles = {
  "邹柏青" => "java内部是如何处理判断一个对象是否被实例化的？",
  "徐华建" => "Java 中的接口有什么作用？",
  "刘青"   => "什么是对象持久化，与数据序列化有何联系？",
  "张无忌" => "C语言中参数向量argv问题",
  "彭思诗" => "java如何用byte[]构造BufferedImage,处理之后怎么再输出为byte[]?",
  "张无忌2" => "java如不想么每次都判空 if(o !=null) 怎么做？",
  "陶宣宣" => "关于电梯算法",
  "刘遂辉" => "有哪些算法的延伸阅读书籍可以推荐下吗？",
  "张无忌3" => "Java里ClassName.this和this有什么不一样",
  "李华"   =>  "插值查找的问题"
}

DemoQuestions = DemoQuestionTitles.map do |creator, title|
  q = DemoQuestion.new
  q.title = title
  q.creator = creator
  q.creator = '张无忌' if creator.include? '张无忌'
  q.teacher_user = "张三丰"
  q.has_answered = [true, false][rand 2]
  q.has_answered = true if creator.include? '张无忌'
  q
end.shuffle

HMMQuestions = DemoQuestions.select {|q| q.creator == '张无忌'}.sort {|a, b| a.title <=> b.title}
