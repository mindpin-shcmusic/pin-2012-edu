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
  
  include Removable
  include Paginated
  include HomeworkAttachment::OwnerMethods

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

  define_index do
    indexes real_name, :sortable => true

    where('is_removed = 0')
  end
end
