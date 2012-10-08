class Question < ActiveRecord::Base
  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => :creator_id

  has_one :answer


  module UserMethods
    def self.included(base)
      base.has_many :questions, :class_name => 'Question', :foreign_key => :creator_id
      base.send(:include,InstanceMethod)
    end
    
    module InstanceMethod
   
    end
  end
end
