require 'class_list'
require 'course_list'
require 'teacher_list'

teams    =   CLASS_LIST.to_a[0, 64]
courses  =  COURSE_LIST.compact.uniq
teachers = TEACHER_LIST.compact.uniq
START_TIME = Time.now

def time_consumed
  Time.now - START_TIME
end

puts '>>>>>>>>>>>>>>>> seeding teams, students, teachers and courses sample data....'
ActiveRecord::Base.transaction do 
  teams.reduce(0) {|counter, team|

    puts ">>>>>>>> seeding teacher-#{counter}: #{teachers[counter]}"
    teacher_user = User.create(:name     => "teacher#{counter}",
                               :email    => "teacher#{counter}@teacher.dev",
                               :password => '1234')

    raise teacher_user.errors.messages.to_s if teacher_user.errors.any?


    teacher = Teacher.create(:real_name => teachers[counter],
                             :user      => teacher_user)
    puts ">>>>>>>> done! (#{time_consumed} seconds)"

    student_counter = 0
    students = team[1].map {|name|
      puts ">>>>>>>> seeding #{team[0].to_s}-student-#{counter}_#{student_counter}: #{name}"

      student_user = User.create(:name     => "student#{counter}0#{student_counter}",
                                 :email    => "student#{team[0].to_s}#{student_counter}@student.dev",
                                 :password => '1234')

      raise student_user.errors.messages.to_s if student_user.errors.any?

      student = Student.create(:real_name => name,
                               :user      => student_user)

      student_counter += 1

      puts ">>>>>>>> done! (#{time_consumed} seconds)"

      student
    }

    puts ">>>>>>>> seeding team-#{counter}: #{team[0].to_s}"

    team = Team.create(:name     => team[0].to_s,
                       :teacher  => teacher,
                       :students => students)

    puts ">>>>>>>> done! (#{time_consumed} seconds)"

    counter + 1
  }
  
  Teacher.all.reduce(0) {|counter, teacher|
    puts ">>>>>>>> seeding course-#{counter}: #{courses[counter]}"

    Course.create(:name     => courses[counter],
                  :teacher  => teacher,
                  :students => Student.all[counter, 30])

    puts ">>>>>>>> done! (#{time_consumed} seconds)"

    counter + 1
  }
end
puts ">>>>>>>>>>>>>>>> seeding finished! (#{time_consumed} seconds)"
