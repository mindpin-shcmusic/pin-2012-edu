class Homework < BuildDatabaseAbstract
  # --- 模型关联
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  has_many :homework_assigns
  
  # 未提交作业学生
  has_many :unsubmitted_students, :through => :homework_assigns, :source => :creator, :conditions => ['is_submit = ?', false]
  # 已提交作业学生
  has_many :submitted_students, :through => :homework_assigns, :source => :creator, :conditions => ['is_submit = ?', true]
  
  accepts_nested_attributes_for :homework_assigns
  
  # --- 校验方法
  validates :title, :content, :presence => true
  
  
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :homeworks, :foreign_key => :creator_id
      
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      # nothing ...
    end
  end
end
