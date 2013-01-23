# -*- coding: utf-8 -*-
class DemoQuestion
  attr_accessor :title, :teacher_user, :creator, :has_answered, :created_at, :link
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
  q.link = '/questions?demo=show1'
  q
end.shuffle

ZYQuestions = DemoQuestions.select {|q| q.creator == '赵云'}.sort {|a, b| a.title <=> b.title}

class DemoAnswer
  attr_accessor :score, :content, :creator, :comments, :attachment
end

PlainAnswers = [
                ['关羽', 4, %|<p>这是是工程设计上常见的问题，一般的解决方案就是 @诸葛亮 所说的<a href="http://en.wikipedia.org/wiki/Null_Object_pattern" target="_blank" rel="nofollow" title="NullObject模式">NullObject模式</a>。本来想投 @诸葛亮 的答案赞成票，但还是觉得说得有些复杂了。</p><p>简单来说就是<strong>有一个NullObject与原有业务对象实现相同的接口（或继承同一个父类），让客户端调用时可以无感知（也不必判定null）</strong>。</p><p>有一个很好的例子就是著名JSON解析框架<a href="http://jackson.codehaus.org/" target="_blank" rel="nofollow" title="Jackson">Jackson</a>。以下代码是Jackson从一段JSON中获取其一级子节点lv1下的二级子节点lv2的内容：</p><pre class="prettyprint"><span class="typ">JsonNode</span><span class="pln"> root </span><span class="pun">=</span><span class="pln"> </span><span class="pun">...;</span><span class="pln"><br></span><span class="typ">JsonNode</span><span class="pln"> child </span><span class="pun">=</span><span class="pln"> root</span><span class="pun">.</span><span class="kwd">get</span><span class="pun">(</span><span class="str">"lv1"</span><span class="pun">).</span><span class="kwd">get</span><span class="pun">(</span><span class="str">"lv2"</span><span class="pun">);</span></pre><p>以上代码很可能遇到lv1不存在的情况，因此第一个get()就会返回null，那么第二个get()执行时自然就抛出NullPointerException了。为了解决这个问题，作者提供了path方法来替代get方法：</p><pre class="prettyprint"><span class="typ">JsonNode</span><span class="pln"> root </span><span class="pun">=</span><span class="pln"> </span><span class="pun">...;</span><span class="pln"><br></span><span class="typ">JsonNode</span><span class="pln"> child </span><span class="pun">=</span><span class="pln"> root</span><span class="pun">.</span><span class="pln">path</span><span class="pun">(</span><span class="str">"lv1"</span><span class="pun">).</span><span class="pln">path</span><span class="pun">(</span><span class="str">"lv2"</span><span class="pun">);</span></pre><p>当lv1不存在时，path()返回一个JsonNode的子类叫做MissingNode（但客户端暂时无需知道），MissingNode的path方法则继续返回MissingNode，这样无论这个链式调用写多长都不会抛出任何异常。</p><p>直到最后客户端调用完成后检查返回结果是否为MissingNode：</p><pre class="prettyprint"><span class="kwd">if</span><span class="pln"> </span><span class="pun">(</span><span class="pln">child</span><span class="pun">.</span><span class="pln">isMissingNode</span><span class="pun">())</span><span class="pln"> </span><span class="pun">{</span><span class="pln"> </span><span class="pun">...</span><span class="pln"> </span><span class="pun">}</span></pre>|],
                ['诸葛亮', 2, %|<p>有一种模式叫NullObject，意思就是建立一个专用的空对象，以此来代表结果为空。比如这样：</p><pre class="prettyprint"><span class="kwd">public</span><span class="pln"> </span><span class="kwd">interface</span><span class="pln"> </span><span class="typ">MyObj</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; </span><span class="kwd">public</span><span class="pln"> </span><span class="typ">String</span><span class="pln"> someOp</span><span class="pun">();</span><span class="pln"><br></span><span class="pun">}</span><span class="pln"><br><br></span><span class="kwd">public</span><span class="pln"> </span><span class="kwd">class</span><span class="pln"> </span><span class="typ">NullObj</span><span class="pln"> </span><span class="kwd">implements</span><span class="pln"> </span><span class="typ">MyObj</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; </span><span class="kwd">public</span><span class="pln"> </span><span class="typ">String</span><span class="pln"> someOp</span><span class="pun">()</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="kwd">return</span><span class="pln"> </span><span class="str">"It's a content of NullObj"</span><span class="pun">;</span><span class="pln"> </span><span class="com">// 或者抛出一个特定异常，又或者打印出一条警告信息</span><span class="pln"><br>&nbsp; </span><span class="pun">}</span><span class="pln"><br></span><span class="pun">}</span><span class="pln"><br><br></span><span class="kwd">public</span><span class="pln"> </span><span class="kwd">class</span><span class="pln"> </span><span class="typ">NormalObj</span><span class="pln"> </span><span class="kwd">implements</span><span class="pln"> </span><span class="typ">MyObj</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; </span><span class="kwd">public</span><span class="pln"> </span><span class="typ">String</span><span class="pln"> someOp</span><span class="pun">()</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="typ">String</span><span class="pln"> result </span><span class="pun">=</span><span class="pln"> </span><span class="kwd">null</span><span class="pun">;</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="com">// 执行一些正常的代码</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="kwd">return</span><span class="pln"> result</span><span class="pun">;</span><span class="pln"><br>&nbsp; </span><span class="pun">}</span><span class="pln"><br></span><span class="pun">}</span></pre><p>用法：</p><p>1、建立全局常量：</p><pre class="prettyprint"><span class="kwd">public</span><span class="pln"> </span><span class="kwd">enum</span><span class="pln"> </span><span class="typ">Constants</span><span class="pln"> </span><span class="pun">{</span><span class="pln"> </span><span class="com">//这种写单例的方式在《Effective Java》中被推荐过，非常好的实现方式。</span><span class="pln"><br>&nbsp; ONE</span><span class="pun">;</span><span class="pln"><br>&nbsp; </span><span class="kwd">public</span><span class="pln"> </span><span class="kwd">final</span><span class="pln"> </span><span class="typ">MyObj</span><span class="pln"> NULL_OBJ </span><span class="pun">=</span><span class="pln"> </span><span class="kwd">new</span><span class="pln"> </span><span class="typ">NullObj</span><span class="pun">();</span><span class="pln"> </span><span class="com">//如果用enum写单例的话这里就不用static修饰符了。</span><span class="pln"><br></span><span class="pun">}</span></pre><p>2、被调用的代码在条件符合的时候返回NullObj：</p><pre class="prettyprint"><span class="kwd">public</span><span class="pln"> </span><span class="kwd">class</span><span class="pln"> </span><span class="typ">Server</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br></span><span class="pun">...</span><span class="pln"><br>&nbsp; </span><span class="kwd">public</span><span class="pln"> </span><span class="typ">MyObj</span><span class="pln"> receive</span><span class="pun">(</span><span class="typ">String</span><span class="pln"> param</span><span class="pun">)</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="kwd">if</span><span class="pln"> </span><span class="pun">(</span><span class="pln">param </span><span class="pun">==</span><span class="pln"> </span><span class="kwd">null</span><span class="pun">)</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; &nbsp; &nbsp; </span><span class="typ">System</span><span class="pun">.</span><span class="kwd">out</span><span class="pun">.</span><span class="pln">println</span><span class="pun">(</span><span class="str">"..."</span><span class="pun">);</span><span class="pln"> </span><span class="com">//记录一些log</span><span class="pln"><br>&nbsp; &nbsp; &nbsp; </span><span class="kwd">return</span><span class="pln"> </span><span class="typ">Constants</span><span class="pun">.</span><span class="pln">ONE</span><span class="pun">.</span><span class="pln">NULL_OBJ</span><span class="pun">;</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="pun">}</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="typ">MyObj</span><span class="pln"> result </span><span class="pun">=</span><span class="pln"> </span><span class="kwd">null</span><span class="pun">;</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="pun">...</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="kwd">return</span><span class="pln"> result</span><span class="pun">;</span><span class="pln"><br>&nbsp; </span><span class="pun">}</span><span class="pln"><br></span><span class="pun">...</span><span class="pln"><br></span><span class="pun">}</span></pre><p>3、在调用方：</p><pre class="prettyprint"><span class="kwd">public</span><span class="pln"> </span><span class="kwd">class</span><span class="pln"> </span><span class="typ">Client</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; </span><span class="kwd">public</span><span class="pln"> result send</span><span class="pun">(</span><span class="typ">String</span><span class="pln"> content</span><span class="pun">)</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="typ">Server</span><span class="pln"> server </span><span class="pun">=</span><span class="pln"> </span><span class="kwd">null</span><span class="pun">;</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="typ">String</span><span class="pln"> result </span><span class="pun">=</span><span class="pln"> </span><span class="kwd">null</span><span class="pun">;</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="kwd">try</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; &nbsp; &nbsp; </span><span class="pun">...</span><span class="pln"> </span><span class="com">//初始化server</span><span class="pln"><br>&nbsp; &nbsp; &nbsp; </span><span class="typ">MyObj</span><span class="pln"> myObj </span><span class="pun">=</span><span class="pln"> server</span><span class="pun">.</span><span class="pln">receive</span><span class="pun">(</span><span class="pln">content</span><span class="pun">);</span><span class="pln"><br>&nbsp; &nbsp; &nbsp; result </span><span class="pun">=</span><span class="pln"> myObj</span><span class="pun">.</span><span class="pln">someOp</span><span class="pun">();</span><span class="pln"> </span><span class="com">//如果你前面选择的是抛出特定异常，则这行代码就必须放在try-catch语句块中了</span><span class="pln"><br>&nbsp; &nbsp; &nbsp; </span><span class="com">// 后续的操作就非常灵活了，或比对结果字符串或catch特定异常，取决于你的NullObj是怎么实现的</span><span class="pln"><br>&nbsp; &nbsp; &nbsp; </span><span class="pun">...</span><span class="pln"><br>&nbsp; &nbsp; </span><span class="pun">}</span><span class="pln"> </span><span class="kwd">catch</span><span class="pln"> </span><span class="pun">(</span><span class="typ">Exception</span><span class="pln"> e</span><span class="pun">)</span><span class="pln"> </span><span class="pun">{</span><span class="pln"><br>&nbsp; &nbsp; &nbsp; </span><span class="pun">...</span><span class="pln"> <br>&nbsp; &nbsp; </span><span class="pun">}</span><span class="pln"><br>&nbsp; </span><span class="pun">}</span><span class="pln"><br></span><span class="pun">}</span></pre><p>当然，通过捕获异常来进行流程控制的方式是不被推荐的。NullObject很灵活，可以做出很多扩展性很强的实现方案。</p>|, true, true],
                ['张飞', 0, '<p>三元运算符</p>']
               ]

class DemoComment
  attr_accessor :creator, :date, :content
end

PlainZGLAComments = [
                     ['张飞', '2013年01月20日', '<p>醍醐灌顶！</p>']
                    ]

PlainZYQComments = [
                    ['虞姬', '2013年01月15日', '<p>貌似没有比较好的方法. 一般如果返回集合时,没有东西可以返回一个空的集合.</p>'],
                    ['马超', '2013年01月15日', '<p>要是有类似 coffee 的 Existential Operator(?.) 或者 rails 中的 try 就好了</p>']
                   ]

ZGLAComments = PlainZGLAComments.map do |attrs|
  c = DemoComment.new
  c.creator = attrs[0]
  c.date = attrs[1]
  c.content = attrs[2]
  c
end

ZYQComments = PlainZYQComments.map do |attrs|
  c = DemoComment.new
  c.creator = attrs[0]
  c.date = attrs[1]
  c.content = attrs[2]
  c
end

DemoAnswers = PlainAnswers.map do |attrs|
  a = DemoAnswer.new
  a.creator = attrs[0]
  a.score = attrs[1]
  a.content = attrs[2]
  a.comments = attrs[3] ? ZGLAComments : []
  a.attachment = '相关资料.zip' if attrs[4]
  a
end
