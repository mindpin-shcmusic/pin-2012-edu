# -*- coding: utf-8 -*-
dirty_association_owners = User.all.select {|user| !user.send(:is_teacher_or_student?)}

puts ">>>>>>>> 即将删除#{dirty_association_owners.count}个用户有关的脏数据."
dirty_association_owners.each do |user|
  user.course_students.destroy_all
  user.team_student && user.team_student.destroy
end
puts '>>>>>>>> 删除完毕!'
