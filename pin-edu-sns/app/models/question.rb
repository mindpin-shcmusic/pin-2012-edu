class Question < ActiveRecord::Base
  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => :creator_id

  has_one :answer

  scope :with_teacher, lambda {|teacher| {:conditions => ['teacher_user_id = ?', teacher.id]}}
  scope :answered, where(:has_answered => true)
  scope :unanswered, where(:has_answered => false)



  module UserMethods
    def self.included(base)
      base.has_many :questions, :class_name => 'Question', :foreign_key => :creator_id
      base.send(:include,InstanceMethod)
    end
    
    module InstanceMethod
   
    end
  end

  include ModelRemovable

end
