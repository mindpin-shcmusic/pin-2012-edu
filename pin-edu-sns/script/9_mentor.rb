ActiveRecord::Base.transaction do
  ActiveRecord::Base.connection.execute("TRUNCATE mentor_courses")
  ActiveRecord::Base.connection.execute("TRUNCATE mentor_notes")
  ActiveRecord::Base.connection.execute("TRUNCATE mentor_students")

  teachers = Teacher.find(:all, :order => "id", :limit => 5).reverse
  teachers.each do |teacher|
    MentorCourse.create(:user => teacher.user, :course => "专题课程-#{teacher.id}")
  end
  
  (1...10).each do |i|
    MentorNote.create(:title => "导师选择 - #{i}")
  end
  
  
  students = Student.find(:all, :order => "id", :limit => 5).reverse
  mentor_courses = MentorCourse.all

  MentorNote.all.each do |mentor_note|
    i = (1..5).to_a.sample
    i.times do |n|
      count = (0..4).to_a.sample
      number1 = (0..4).to_a.sample
      number2 = (0..4).to_a.sample
      number3 = (0..4).to_a.sample

      MentorStudent.create(
        :mentor_note => mentor_note,
        :student_user_id => students[count].user_id,
        :mentor_course1 => mentor_courses[number1].id,
        :mentor_course2 => mentor_courses[number2].id,
        :mentor_course3 => mentor_courses[number3].id
      )
    end


  end

 end