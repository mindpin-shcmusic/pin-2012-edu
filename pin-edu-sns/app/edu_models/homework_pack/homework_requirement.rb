# -*- coding: no-conversion -*-
class HomeworkRequirement < ActiveRecord::Base
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

  def upload_by(user)
    user.homework_student_uploads.find_by_requirement_id(self.id)
  end

  def is_uploaded_by?(user)
    !self.upload_by(user).blank?
  end
  
  module UserMethods
    def self.included(base)
      base.has_many :homework_requirements,
                    :foreign_key => 'creator_id'

      base.send(:include,InstanceMethod)
    end
    
    module InstanceMethod
      
    end
  end
end
