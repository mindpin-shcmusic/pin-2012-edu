# -*- coding: utf-8 -*-
class DemoQuestion
  attr_accessor :title, :teacher_user, :creator, :has_answered, :created_at
end

DemoQuestionTitles = {
  '马超'  => 'java内部是如何处理判断一个对象是否被实例化的？',
  '关羽'  => 'Java中的接口有什么作用？',
  '张飞'  => '什么是对象持久化，与数据序列化有何联系？',
  '赵云'  => '参数向量argv问题',
  '虞姬'  => 'java如何用byte[]构造BufferedImage,处理之后怎么再输出为byte[]?',
  '赵云2' => 'java如不想么每次都判空 if(o !=null) 怎么做？',
  '马谡'  => '关于电梯算法',
  '姜维'  => '为什么这里会NullPointerException？',
  '赵云3' => 'Java里ClassName.this和this有什么不一样',
  '蒋琬'  => '插值查找的问题',
  '赵云4' => '有Java的布隆过滤器实现吗？',
  '赵云5' => 'Integer和int有什么不同？',
  '董允'  => '为什么这里使用for..in循环会报错？'
}

DemoQuestions = DemoQuestionTitles.map do |creator, title|
  q = DemoQuestion.new
  q.title = title
  q.creator = creator
  q.creator = '赵云' if creator.include? '赵云'
  q.teacher_user = '诸葛亮'
  q.created_at = [1, 2, 3][rand 3].day.ago
  q.has_answered = [true, false][rand 2]
  q.has_answered = true if creator.include? '赵云'
  q
end.shuffle

HMMQuestions = ZYQuestions = DemoQuestions.select {|q| q.creator == '赵云'}.sort {|a, b| a.title <=> b.title}
