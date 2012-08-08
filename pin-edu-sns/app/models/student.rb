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
  
  include Removable
  include Paginated

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

  define_index do
    indexes real_name, :sortable => true

    where('is_removed = 0')
  end
end
