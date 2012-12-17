# -*- coding: utf-8 -*-
$students = ["陈芳芳", "丁云燕", "李翠", "刘微", "朱康敏", "张毅", "何圣平", "钟杨", "李伟", "邱梅丁",
            "卢忠庆", "刘绍峰", "罗佳为", "涂鹏", "钱梦辉", "詹立新", "朱志亮", "杨辉灿", "石仁闯", "刘伟",
            "张新泉", "毛林", "阳永梁", "吴明佳", "焦水飞", "李岳桐", "邓慧颖", "赖蕾", "易翠", "李娅楠",
            "彭思诗", "项琪琪", "陶宣宣", "鄢韬", "刘遂辉", "郭朝阳", "曾涛", "傅强", "刘青", "聂建元",
            "曾江劲", "邹柏青", "徐华建", "柯晔", "叶青蓝", "雷鹏", "郑海翔", "彭嘉欣", "方星", "万鹏",
            "徐中文", "金刚", "徐登鹏", "乔玉明", "王奇", "邓雪莹", "徐文琦", "周文君", "徐雨静", "陈雨馨",
            "段家伟", "邹剑", "刘锡清", "卓来荣", "陈联斌", "杨强", "钟易程", "王健", "罗贤鹏", "邓来先",
            "罗剑钧", "罗潇", "朱锐", "吴梦华", "刘丹", "胡仁武", "陈建平", "江海涛", "丁川", "颉德武",
            "占迎辉", "宋杭原", "赵琪", "周禹希", "朱仪菲", "郝磊", "吕鸿翔", "陈鹏", "熊峰", "周超",
            "邓远平", "廖卓鸿", "蓝业强", "王世焜", "曾辉", "易思诚", "周海阳", "游磊", "吴文平", "颜良贵",
            "韩枫", "杨明明", "巫新华", "廖晨", "胡志恒", "淦帆帆", "喻良成", "戴晓伟", "郭颖超", "宋国兴",
            "孟雪", "贺小火", "姜皓", "胡飞", "杨天星", "赖宗亮", "彭天扬", "刘志鹏", "杨长雄", "杨威",
            "邓强", "袁建成", "邓灵杰", "袁诗辉", "刘府阳", "宁平平", "甘锋", "何辉海", "张晨阳", "张炜鑫",
            "彭炜", "彭光宇", "杨磊", "宋雪成", "胡志高", "孙月振", "欧阳晓丽", "汪滢", "梅芬", "陈传其",
            "杨阳", "王浩", "赵志诚", "王宁", "吕立", "鞠少聪", "金融泉", "刘舰", "张馥川", "张燕山"]

$teachers = ["蔡嗣经", "陈广平", "高永涛", "胡乃联",
            "姜福兴", "李克庆", "李仲学", "刘胜富",
            "明士祥", "宋卫东", "吴爱祥", "谢玉玲",
            "徐九华", "杨鹏", "李翠平", "刘保顺",
            "吕文生", "毛市龙", "王洪江", "王进强"]

def tail_to_head(array)
  ary = array.dup
  tail = ary.pop
  ary.unshift tail
end

defpack 1 do
  semester = Semester.get(2012, :B)

  admin = User.create(:name => 'admin',
                      :email => 'admin@edu.dev',
                      :password => '1234')

  admin.set_role :admin

  puts ">>>>>>>> 管理员"

  $students.reduce(1) do |count, name|
    user = User.create(:name => "student#{count}",
                       :email => "student#{count}@edu.dev",
                       :password => '1234')

    user.set_role :student

    student = Student.create(:real_name => name,
                             :sid => "sid-#{count}",
                             :user => user)

    puts ">>>>>>>> 学生: #{student.real_name}; sid: #{student.sid}"

    count + 1
  end

  $teachers.reduce(1) do |count, name|
    user = User.create(:name => "teacher#{count}",
                       :email => "teacher#{count}@edu.dev",
                       :password => '1234')

    user.set_role :teacher

    teacher = Teacher.create(:real_name => name,
                             :tid => "tid-#{count}",
                             :user => user)

    puts ">>>>>>>> 老师: #{teacher.real_name}; tid: #{teacher.tid}"

    count + 1
  end

end
