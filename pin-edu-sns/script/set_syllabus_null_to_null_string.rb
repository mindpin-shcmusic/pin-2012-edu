ActiveRecord::Base.transaction do
  courses = Course.where("syllabus is null")
  count = courses.count
  courses.each_with_index do |course,index|
    p "#{index+1}/#{count}"

    course.syllabus = ""
    course.save
  end
end