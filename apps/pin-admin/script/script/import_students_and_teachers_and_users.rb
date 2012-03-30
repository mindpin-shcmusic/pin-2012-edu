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
  

