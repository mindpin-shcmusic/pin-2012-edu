class Student < BuildDatabaseAbstract
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
  validates :real_name, :presence=>true
  validates :sid, :uniqueness => {
    :if => Proc.new { |student| !student.sid.blank? }
  }
  
  validates :real_name, :presence=>true
  validates :sid, :uniqueness => { :if => Proc.new { |student| !student.sid.blank? } }
  
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
end
