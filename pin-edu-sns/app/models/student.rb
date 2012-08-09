# -*- coding: utf-8 -*-
class Student < ActiveRecord::Base
  belongs_to :user

  has_many :homework_assigns
  
  # 学生所有被分配作业
  has_many :homeworks, :through => :homework_assigns
      
  # 学生未过期作业
  has_many :undeadline_student_homeworks,
           :through => :homework_assigns,
           :source => :homework,
           :conditions => ['homeworks.deadline > ?', Time.now] 

  # 学生已过期作业
  has_many :deadline_student_homeworks,
           :through => :homework_assigns,
           :source => :homework,
           :conditions => ['homeworks.deadline <= ?', Time.now]

  
  # --- 校验方法
  validates :real_name, :presence => true
  validates :sid, :uniqueness => { :if => Proc.new { |student| !student.sid.blank? } }
  validates :user, :presence => true

  validate do |student|
    if !student.user_id.blank?
      students = Student.find_all_by_user_id(student.user_id)
      teachers = Teacher.find_all_by_user_id(student.user_id)
      other_students = students-[student]
      if !other_students.blank? || !teachers.blank?
        errors.add(:user, "该用户账号已经被其他教师或者学生绑定")
      end
    end
  end

  accepts_nested_attributes_for :user

  def self.import_from_csv(file)
    ActiveRecord::Base.transaction do
      parse_csv_file(file) do |row,index|
        student = Student.new(
          :real_name => row[0], :sid => row[1],
          :user_attributes => {
            :name => row[2],
            :email => row[3],
            :password => row[4],
            :password_confirmation => row[4]
          })
        if !student.save
          message = student.errors.first[1]
          raise "第 #{index+1} 行解析出错,可能的错误原因 #{message} ,请修改后重新导入"
        end
      end
    end
  end

  module UserMethods
    def self.included(base)
      base.has_one :student
      base.send(:include,InstanceMethod)
    end
    
    module InstanceMethod
      def is_student?
        !self.student.blank?
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
