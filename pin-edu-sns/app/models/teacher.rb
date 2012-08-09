# -*- coding: utf-8 -*-
class Teacher < ActiveRecord::Base
  belongs_to :user
  
  validates :real_name, :presence => true
  validates :tid, :uniqueness => { :if => Proc.new { |teacher| !teacher.tid.blank? } }
  validates :user, :presence => true
  validate do |teacher|
    if !teacher.user_id.blank?
      teachers = Teacher.find_all_by_user_id(teacher.user_id)
      students = Student.find_all_by_user_id(teacher.user_id)
      other_teachers = teachers-[teacher]
      if !other_teachers.blank? || !students.blank?
        errors.add(:user, "该用户账号已经被其他教师或者学生绑定")
      end
    end
  end

  accepts_nested_attributes_for :user
  
  def self.import_from_csv(file)
    ActiveRecord::Base.transaction do
      parse_csv_file(file) do |row,index|
        teacher = Teacher.new(
          :real_name => row[0], :tid => row[1],
          :user_attributes => {
            :name => row[2],
            :email => row[3],
            :password => row[4],
            :password_confirmation => row[4]
          })
        if !teacher.save
          message = teacher.errors.first[1]
          raise "第 #{index+1} 行解析出错,可能的错误原因 #{message} ,请修改后重新导入"
        end
      end
    end
  end

  module UserMethods
    def self.included(base)
      base.has_one :teacher
      base.send(:include,InstanceMethod)
      base.send(:extend,ClassMethod)
      base.scope  :student_role,
        :joins=>"inner join students on students.user_id = users.id"
      base.scope  :teacher_role,
        :joins=>"inner join teachers on teachers.user_id = users.id"
    end
    
    module InstanceMethod
      def is_teacher?
        !self.teacher.blank?
      end
      
      def real_name
        self.teacher.real_name if is_teacher?
        self.student.real_name if is_student?
        self.name
      end
    end
    
    module ClassMethod
      def no_role
        self.all-self.student_role-self.teacher_role
      end
    end
    
  end

  include ModelRemovable
  include Paginated

  define_index do
    indexes real_name, :sortable => true

    where('is_removed = 0')
  end
end
