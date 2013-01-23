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
  TEACHING_PLAN_2.progress = "29%"

  TEACHING_PLAN_3 = TeachingPlan.new
  TEACHING_PLAN_3.title = "JavaScript开发教学方案"
  TEACHING_PLAN_3.desc = "给有一定HTML基础的学生准备的教学方案，通过这个方案的学习，让学生可以在HTML静态页面的基础上做一些更复杂交互的页面"
  TEACHING_PLAN_3.creator = User.find_by_name('zhugeliang')
  TEACHING_PLAN_3.progress = "37%"
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

  TEACHING_PLAN_2.chapters = []

  chapter_2_1 = Chapter.new
  chapter_2_1.title = "基本语法"
  chapter_2_1.desc = "详细介绍Javascript的基本语法"
  TEACHING_PLAN_3.add_chapter(chapter_2_1)


  homework = Homework.new
  homework.title = "类和对象的基本概念"
  homework.desc = "完成课后习题,试着用形象的语言来描述自己对类和对象的理解"
  homework.creator = User.find_by_name("zhugeliang")
  homework.created_at = Time.now-3.second
  homework.deadline = Time.now+1.day
  homework.attachments = ["作业习题.doc"]
  homework.requirements = [
    '编写一个Hello类，根据附件要求，实现hello_world()类方法',
    '编写一个Book类，根据附件要求，实现read()实例方法',
    '编写一个Store类，根据附件要求，实现add()实例方法'
  ]
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
    attr_accessor :title, :desc, :answers, :creator, :comments, :best_answer,
      :teacher_user, :created_at, :has_answered, :link
  end

  class Answer
    attr_accessor :content, :attachment, :creator, :comments, :score
    def initialize(options)
      self.creator = options[:creator]
      self.score = options[:score] || 0
      self.content = options[:content]
      self.comments = options[:comments]
      self.attachment = options[:attachment]
    end
  end

  class Comment
    attr_accessor :content, :creator, :created_at
    def initialize(options)
      self.content = options[:content]
      self.creator = options[:creator]
      self.created_at = options[:created_at]
    end
  end

  zhaoyun = User.find_by_name("zhaoyun")
  guanyu = User.find_by_name("guanyu")
  zhugeliang = User.find_by_name('zhugeliang')

  question_1 = Question.new
  question_1.title = "java如不想么每次都进行空值判断 if(o!=null) 怎么做？"
  question_1.desc = "<p>涉及到对象操作 object.xxxx(),如果对象为null则会抛异常，如果每次都if(o !=null) 代码很丑陋</p><p>一种做法是创建对象或者方法返回对象时都new一个对象而不是返回null<br>\n不过这样有时也不太好，比如结果为空的时候返回null更合理一点</p><p>有更好的建议么 ？</p>"
  question_1.creator = zhaoyun
  question_1.teacher_user = zhugeliang
  question_1.created_at = [1, 2, 3][rand 3].day.ago
  question_1.has_answered = true
  question_1.link = "/o1/question?step=1"
  question_1.best_answer = "建议使用NullObject模式。"


  comment_1 = Comment.new(
    :content => '<p>貌似没有比较好的方法. 一般如果返回集合时,没有东西可以返回一个空的集合.</p>',
    :creator => User.find_by_name('wangping'),
    :created_at => '2013年01月15日'
  )
  comment_2 = Comment.new(
    :content => '<p>要是有类似 coffee 的 Existential Operator(?.) 或者 rails 中的 try 就好了</p>',
    :creator => User.find_by_name('zhoucang'),
    :created_at => '2013年01月15日'
  )
  question_1.comments = [comment_1,comment_2]

  answer_1_1 = Answer.new(
    :creator => User.find_by_name("guanyu"),
    :score => 4,
    :content => %|<p>这是是工程设计上常见的问题，一般的解决方案就是 @诸葛亮 所说的<a href="http://en.wikipedia.org/wiki/Null_Object_pattern" target="_blank" rel="nofollow" title="NullObject模式">NullObject模式</a>。本来想投 @诸葛亮 的答案赞成票，但还是觉得说得有些复杂了。</p><p>简单来说就是<strong>有一个NullObject与原有业务对象实现相同的接口（或继承同一个父类），让客户端调用时可以无感知（也不必判定null）</strong>。</p><p>有一个很好的例子就是著名JSON解析框架<a href="http://jackson.codehaus.org/" target="_blank" rel="nofollow" title="Jackson">Jackson</a>。以下代码是Jackson从一段JSON中获取其一级子节点lv1下的二级子节点lv2的内容：</p><pre class="prettyprint"><span class="typ">JsonNode</span><span class="pln"> root </span><span class="pun">=</span><span class="pln"> </span><span class="pun">...;</span><span class="pln"><br></span><span class="typ">JsonNode</span><span class="pln"> child </span><span class="pun">=</span><span class="pln"> root</span><span class="pun">.</span><span class="kwd">get</span><span class="pun">(</span><span class="str">"lv1"</span><span class="pun">).</span><span class="kwd">get</span><span class="pun">(</span><span class="str">"lv2"</span><span class="pun">);</span></pre><p>以上代码很可能遇到lv1不存在的情况，因此第一个get()就会返回null，那么第二个get()执行时自然就抛出NullPointerException了。为了解决这个问题，作者提供了path方法来替代get方法：</p><pre class="prettyprint"><span class="typ">JsonNode</span><span class="pln"> root </span><span class="pun">=</span><span class="pln"> </span><span class="pun">...;</span><span class="pln"><br></span><span class="typ">JsonNode</span><span class="pln"> child </span><span class="pun">=</span><span class="pln"> root</span><span class="pun">.</span><span class="pln">path</span><span class="pun">(</span><span class="str">"lv1"</span><span class="pun">).</span><span class="pln">path</span><span class="pun">(</span><span class="str">"lv2"</span><span class="pun">);</span></pre><p>当lv1不存在时，path()返回一个JsonNode的子类叫做MissingNode（但客户端暂时无需知道），MissingNode的path方法则继续返回MissingNode，这样无论这个链式调用写多长都不会抛出任何异常。</p><p>直到最后客户端调用完成后检查返回结果是否为MissingNode：</p><pre class="prettyprint"><span class="kwd">if</span><span class="pln"> </span><span class="pun">(</span><span class="pln">child</span><span class="pun">.</span><span class="pln">isMissingNode</span><span class="pun">())</span><span class="pln"> </span><span class="pun">{</span><span class="pln"> </span><span class="pun">...</span><span class="pln"> </span><span class="pun">}</span></pre>|
  )

  answer_1_2_comment = Comment.new(
    :content => '<p>醍醐灌顶！</p>',
    :creator => User.find_by_name('zhangfei'),
    :created_at => '2013年01月20日'
  )
  
  answer_1_2 = Answer.new(
    :creator => User.find_by_name("zhugeliang"),
    :score => 2,
    :content => %|<p>有一种模式叫NullObject，意思就是建立一个专用的空对象，以此来代表结果为空。比如这样：</p><pre class="prettyprint"><span class="kwd">public</span><span class="pln"> </span><span class="kwd">interface</span><span class="pln"> </span><span class="typ">MyObj</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; </span><span class="kwd">public</span><span class="pln"> </span><span class="typ">String</span><span class="pln"> someOp</span><span class="pun">();</span><span class="pln"><br></span><span class="pun">}</span><span class="pln"><br><br></span><span class="kwd">public</span><span class="pln"> </span><span class="kwd">class</span><span class="pln"> </span><span class="typ">NullObj</span><span class="pln"> </span><span class="kwd">implements</span><span class="pln"> </span><span class="typ">MyObj</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; </span><span class="kwd">public</span><span class="pln"> </span><span class="typ">String</span><span class="pln"> someOp</span><span class="pun">()</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="kwd">return</span><span class="pln"> </span><span class="str">"It's a content of NullObj"</span><span class="pun">;</span><span class="pln"> </span><span class="com">// 或者抛出一个特定异常，又或者打印出一条警告信息</span><span class="pln"><br>&nbsp; </span><span class="pun">}</span><span class="pln"><br></span><span class="pun">}</span><span class="pln"><br><br></span><span class="kwd">public</span><span class="pln"> </span><span class="kwd">class</span><span class="pln"> </span><span class="typ">NormalObj</span><span class="pln"> </span><span class="kwd">implements</span><span class="pln"> </span><span class="typ">MyObj</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; </span><span class="kwd">public</span><span class="pln"> </span><span class="typ">String</span><span class="pln"> someOp</span><span class="pun">()</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="typ">String</span><span class="pln"> result </span><span class="pun">=</span><span class="pln"> </span><span class="kwd">null</span><span class="pun">;</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="com">// 执行一些正常的代码</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="kwd">return</span><span class="pln"> result</span><span class="pun">;</span><span class="pln"><br>&nbsp; </span><span class="pun">}</span><span class="pln"><br></span><span class="pun">}</span></pre><p>用法：</p><p>1、建立全局常量：</p><pre class="prettyprint"><span class="kwd">public</span><span class="pln"> </span><span class="kwd">enum</span><span class="pln"> </span><span class="typ">Constants</span><span class="pln"> </span><span class="pun">{</span><span class="pln"> </span><span class="com">//这种写单例的方式在《Effective Java》中被推荐过，非常好的实现方式。</span><span class="pln"><br>&nbsp; ONE</span><span class="pun">;</span><span class="pln"><br>&nbsp; </span><span class="kwd">public</span><span class="pln"> </span><span class="kwd">final</span><span class="pln"> </span><span class="typ">MyObj</span><span class="pln"> NULL_OBJ </span><span class="pun">=</span><span class="pln"> </span><span class="kwd">new</span><span class="pln"> </span><span class="typ">NullObj</span><span class="pun">();</span><span class="pln"> </span><span class="com">//如果用enum写单例的话这里就不用static修饰符了。</span><span class="pln"><br></span><span class="pun">}</span></pre><p>2、被调用的代码在条件符合的时候返回NullObj：</p><pre class="prettyprint"><span class="kwd">public</span><span class="pln"> </span><span class="kwd">class</span><span class="pln"> </span><span class="typ">Server</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br></span><span class="pun">...</span><span class="pln"><br>&nbsp; </span><span class="kwd">public</span><span class="pln"> </span><span class="typ">MyObj</span><span class="pln"> receive</span><span class="pun">(</span><span class="typ">String</span><span class="pln"> param</span><span class="pun">)</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="kwd">if</span><span class="pln"> </span><span class="pun">(</span><span class="pln">param </span><span class="pun">==</span><span class="pln"> </span><span class="kwd">null</span><span class="pun">)</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; &nbsp; &nbsp; </span><span class="typ">System</span><span class="pun">.</span><span class="kwd">out</span><span class="pun">.</span><span class="pln">println</span><span class="pun">(</span><span class="str">"..."</span><span class="pun">);</span><span class="pln"> </span><span class="com">//记录一些log</span><span class="pln"><br>&nbsp; &nbsp; &nbsp; </span><span class="kwd">return</span><span class="pln"> </span><span class="typ">Constants</span><span class="pun">.</span><span class="pln">ONE</span><span class="pun">.</span><span class="pln">NULL_OBJ</span><span class="pun">;</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="pun">}</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="typ">MyObj</span><span class="pln"> result </span><span class="pun">=</span><span class="pln"> </span><span class="kwd">null</span><span class="pun">;</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="pun">...</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="kwd">return</span><span class="pln"> result</span><span class="pun">;</span><span class="pln"><br>&nbsp; </span><span class="pun">}</span><span class="pln"><br></span><span class="pun">...</span><span class="pln"><br></span><span class="pun">}</span></pre><p>3、在调用方：</p><pre class="prettyprint"><span class="kwd">public</span><span class="pln"> </span><span class="kwd">class</span><span class="pln"> </span><span class="typ">Client</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; </span><span class="kwd">public</span><span class="pln"> result send</span><span class="pun">(</span><span class="typ">String</span><span class="pln"> content</span><span class="pun">)</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="typ">Server</span><span class="pln"> server </span><span class="pun">=</span><span class="pln"> </span><span class="kwd">null</span><span class="pun">;</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="typ">String</span><span class="pln"> result </span><span class="pun">=</span><span class="pln"> </span><span class="kwd">null</span><span class="pun">;</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="kwd">try</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; &nbsp; &nbsp; </span><span class="pun">...</span><span class="pln"> </span><span class="com">//初始化server</span><span class="pln"><br>&nbsp; &nbsp; &nbsp; </span><span class="typ">MyObj</span><span class="pln"> myObj </span><span class="pun">=</span><span class="pln"> server</span><span class="pun">.</span><span class="pln">receive</span><span class="pun">(</span><span class="pln">content</span><span class="pun">);</span><span class="pln"><br>&nbsp; &nbsp; &nbsp; result </span><span class="pun">=</span><span class="pln"> myObj</span><span class="pun">.</span><span class="pln">someOp</span><span class="pun">();</span><span class="pln"> </span><span class="com">//如果你前面选择的是抛出特定异常，则这行代码就必须放在try-catch语句块中了</span><span class="pln"><br>&nbsp; &nbsp; &nbsp; </span><span class="com">// 后续的操作就非常灵活了，或比对结果字符串或catch特定异常，取决于你的NullObj是怎么实现的</span><span class="pln"><br>&nbsp; &nbsp; &nbsp; </span><span class="pun">...</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="pun">}</span><span class="pln"> </span><span class="kwd">catch</span><span class="pln"> </span><span class="pun">(</span><span class="typ">Exception</span><span class="pln"> e</span><span class="pun">)</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; &nbsp; &nbsp; </span><span class="pun">...</span><span class="pln"> <br>&nbsp; &nbsp; </span><span class="pun">}</span><span class="pln"><br>&nbsp; </span><span class="pun">}</span><span class="pln"><br></span><span class="pun">}</span></pre><p>当然，通过捕获异常来进行流程控制的方式是不被推荐的。NullObject很灵活，可以做出很多扩展性很强的实现方案。</p>|,
    :attachment => "相关资料.zip",
    :comments => [answer_1_2_comment]
  )

  answer_1_3 = Answer.new(
    :creator => User.find_by_name("zhangfei"),
    :score => 0,
    :content => '<p>三元运算符</p>'
  )

  
  question_1.answers = [answer_1_1,answer_1_2,answer_1_3]

  question_2 = Question.new
  question_2.title = "Java里ClassName.this和this有什么不一样"
  question_2.desc = ""
  question_2.creator = zhaoyun
  question_2.comments = []
  question_2.answers = []
  question_2.teacher_user = zhugeliang
  question_2.created_at = [1, 2, 3][rand 3].day.ago
  question_2.has_answered = true
  question_2.link = "/o1/question?step=1"
  question_2.best_answer = "this是当前类的实例，而ClassName.this是在内部类里内联它的那个类的实例。"

  question_3 = Question.new
  question_3.title = "有Java的布隆过滤器实现吗？"
  question_3.desc = ""
  question_3.creator = zhaoyun
  question_3.comments = []
  question_3.answers = []
  question_3.teacher_user = zhugeliang
  question_3.created_at = [1, 2, 3][rand 3].day.ago
  question_3.has_answered = true
  question_3.link = "/o1/question?step=1"

  question_4 = Question.new
  question_4.title = "Integer和int有什么不同？"
  question_4.desc = ""
  question_4.creator = zhaoyun
  question_4.comments = []
  question_4.answers = []
  question_4.teacher_user = zhugeliang
  question_4.created_at = [1, 2, 3][rand 3].day.ago
  question_4.has_answered = true
  question_4.link = "/o1/question?step=1"

  question_5 = Question.new
  question_5.title = "Java参数向量argv问题"
  question_5.desc = ""
  question_5.creator = zhaoyun
  question_5.comments = []
  question_5.answers = []
  question_5.teacher_user = zhugeliang
  question_5.created_at = [1, 2, 3][rand 3].day.ago
  question_5.has_answered = true
  question_5.link = "/o1/question?step=1"

  question_6 = Question.new
  question_6.title = "java内部是如何处理判断一个对象是否被实例化的？"
  question_6.desc = ""
  question_6.creator = guanyu
  question_6.comments = []
  question_6.answers = []
  question_6.teacher_user = zhugeliang
  question_6.created_at = [1, 2, 3][rand 3].day.ago
  question_6.has_answered = true
  question_6.link = "/o1/question?step=1"

  question_7 = Question.new
  question_7.title = "Java中的接口有什么作用？"
  question_7.desc = ""
  question_7.creator = guanyu
  question_7.comments = []
  question_7.answers = []
  question_7.teacher_user = zhugeliang
  question_7.created_at = [1, 2, 3][rand 3].day.ago
  question_7.has_answered = true
  question_7.link = "/o1/question?step=1"

  question_8 = Question.new
  question_8.title = "什么是对象持久化，与数据序列化有何联系？"
  question_8.desc = ""
  question_8.creator = guanyu
  question_8.comments = []
  question_8.answers = []
  question_8.teacher_user = zhugeliang
  question_8.created_at = [1, 2, 3][rand 3].day.ago
  question_8.has_answered = true
  question_8.link = "/o1/question?step=1"

  question_9 = Question.new
  question_9.title = "java如何用byte[]构造BufferedImage,处理之后怎么再输出为byte[]?"
  question_9.desc = ""
  question_9.creator = guanyu
  question_9.comments = []
  question_9.answers = []
  question_9.teacher_user = zhugeliang
  question_9.created_at = [1, 2, 3][rand 3].day.ago
  question_9.has_answered = true
  question_9.link = "/o1/question?step=1"

  question_10 = Question.new
  question_10.title = "关于电梯算法"
  question_10.desc = ""
  question_10.creator = guanyu
  question_10.comments = []
  question_10.answers = []
  question_10.teacher_user = zhugeliang
  question_10.created_at = [1, 2, 3][rand 3].day.ago
  question_10.has_answered = true
  question_10.link = "/o1/question?step=1"

  question_11 = Question.new
  question_11.title = "Java反射调用一个类，是在编译时执行还是在运行时执行？"
  question_11.desc = ""
  question_11.creator = guanyu
  question_11.comments = []
  question_11.answers = []
  question_11.teacher_user = zhugeliang
  question_11.created_at = [1, 2, 3][rand 3].day.ago
  question_11.has_answered = true
  question_11.link = "/o1/question?step=1"
  question_11.best_answer = %`
    <p>一定是在运行时。<br> 反射的原理是，在运行时，通过反射，可以获取到虚拟机的方法区内装载的所有类信息，从而调用这些类。如果某个类没有被装载，是反射不到的。<br> 至于什么时候适合用到反射，视你的应用场景而定，当有一些类的结构是你无法预知的，但又要视其结构不同而进行不同的调用。<br> 举个例子，做框架，对于使用这个框架的开发者的类的调用。</p>
  `

  question_12 = Question.new
  question_12.title = "NullPointerException的原因?"
  question_12.desc = ""
  question_12.creator = guanyu
  question_12.comments = []
  question_12.answers = []
  question_12.teacher_user = zhugeliang
  question_12.created_at = [1, 2, 3][rand 3].day.ago
  question_12.has_answered = true
  question_12.link = "/o1/question?step=1"
  question_12.best_answer = "NullPointerException发生的原因是操作了一个为null的变量。"

  question_13 = Question.new
  question_13.title = "throw和throws有什么不同？"
  question_13.desc = ""
  question_13.creator = guanyu
  question_13.comments = []
  question_13.answers = []
  question_13.teacher_user = zhugeliang
  question_13.created_at = [1, 2, 3][rand 3].day.ago
  question_13.has_answered = true
  question_13.link = "/o1/question?step=1"
  question_13.best_answer = "throws用于声明一个方法会抛出哪些异常。而throw是在方法体中实际执行抛出异常的动作。如果你在方法中throw一个异常，却没有在方法声明中声明之，编译器会报错。注意error和runtimeexception的子类是例外，无需特别声明。"

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

  class Course
    attr_accessor :title
    def initialize(options)
      self.title = options[:title]
    end
  end

  COURSES = ['Java程序设计', 'Java EE & Android开发培训课程', 'Javascript & jQuery培训课程'].map do |title|
    Course.new(:title => title)
  end

  FAQ = [
    question_1,
    question_2,
    question_11,
    question_12,
    question_13
  ]

end