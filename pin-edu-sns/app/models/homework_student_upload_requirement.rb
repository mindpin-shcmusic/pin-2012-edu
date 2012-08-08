class HomeworkStudentUploadRequirement < ActiveRecord::Base
  belongs_to :creator,
             :class_name => 'User',
             :foreign_key => 'creator_id'

  belongs_to :homework

  has_many :homework_student_uploads,
           :class_name => 'HomeworkStudentUpload',
           :foreign_key => 'requirement_id'
  
  def upload_of_user(user)
    self.homework_student_uploads.where(:creator_id => user.id).first
  end

  module UserMethods
    def self.included(base)
      base.has_many :homework_student_upload_requirements,
                    :foreign_key => 'creator_id'

      base.send(:include,InstanceMethod)
    end
    
    module InstanceMethod
      
    end
  end
end
