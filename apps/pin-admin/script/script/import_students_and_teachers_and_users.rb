# rails runner script/script/import_students_and_teachers_and_users.rb

require "csv"

# teachers
ActiveRecord::Base.transaction do
  
  raw_count = 0
  CSV.open(File.join(Rails.root,"/tmp/teachers.csv"), 'r') do |row|
    raw_count+=1
    
    begin
      real_name = row[0]
      tid = row[1]
      
      user = User.new(:email=>"#{tid}@xxx.com",:name=>real_name,:password=>"123456",:password_confirmation=>"123456")
      user.save!
      
      teacher = Teacher.new(
        :real_name => real_name,
        :tid => tid,
        :user_id => user.id
      )
      teacher.save!
    rescue Exception=>ex
      raise "第 #{raw_count}行解析出错,本次操作已经回滚"
    end
    
  end
end

# students
ActiveRecord::Base.transaction do
  
  raw_count = 0
  CSV.open(File.join(Rails.root,"/tmp/students.csv"), 'r') do |row|
    raw_count+=1
    
    begin
      real_name = row[0]
      sid = row[1]
      
      user = User.new(:email=>"#{sid}@xxx.com",:name=>real_name,:password=>"123456",:password_confirmation=>"123456")
      user.save!
      
      student = Student.new(
        :real_name => real_name,
        :sid => sid,
        :user_id => user.id
      )
      student.save!
    rescue Exception=>ex
      raise "第 #{raw_count}行解析出错,本次操作已经回滚"
    end
    
  end
end


# courses
ActiveRecord::Base.transaction do
  
  raw_count = 0
  CSV.open(File.join(Rails.root,"/tmp/courses.csv"), 'r') do |row|
    raw_count+=1
    
    begin
      name = row[0]
      cid = row[1]
      department = row[2]
      location = row[3]
      
      tid = cid.gsub("c","t")
      teacher = Teacher.find_by_tid(tid)
      
      course = Course.new(
        :name=>name,
        :cid=>cid,
        :department=>department,
        :location=>location,
        :teacher=>teacher
      )
      
      course.save!
    rescue Exception=>ex
      raise "第 #{raw_count}行解析出错,本次操作已经回滚"
    end
    
  end
end

ActiveRecord::Base.transaction do
  
  raw_count = 0
  CSV.open(File.join(Rails.root,"/tmp/teams.csv"), 'r') do |row|
    raw_count+=1
    
    begin
      name = row[0]
      cid = row[1]
      
      tid = cid.gsub("ys","t")
      teacher = Teacher.find_by_tid(tid)
      
      team = Team.new(
        :name=>name,
        :cid=>cid,
        :teacher=>teacher
      )
      team.save!
      
      index = cid.gsub("ys","").to_i
      student = Student.find_by_sid("s01")
      first_id = student.id+((index-1)*5)
      student_ids = [first_id,first_id+1,first_id+2,first_id+3,first_id+4]
      team.student_ids = student_ids 
      
    rescue Exception=>ex
      p ex.message
      puts ex.backtrace*"\n"
      raise "第 #{raw_count}行解析出错,本次操作已经回滚"
    end
    
  end
end

  

