class Todo < BuildDatabaseAbstract
  # --- 模型关联
  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id
  
  validates :content, :creator, :presence => true
  
  validate :check_date_format
  def check_date_format
    if !self.date.blank?
      str = Time.parse(self.date.to_s).strftime("%Y%m%d")
      if str != self.date.to_s
        errors.add(:date,"date 的格式不正确") 
      end
    end
  rescue
    errors.add(:date,"date 的格式不正确") 
  end
  
  def do_complete
    if !self.completed
      self.completed = true 
      self.save
    end
  end
  
  module UserMethods
    def self.included(base)
      base.has_many :all_todos, :class_name => 'Todo', :foreign_key => "creator_id"
      
      base.has_many :unexpired_todos, :class_name => 'Todo', :foreign_key => "creator_id",
        :conditions => "todos.completed is not true and (todos.date is null or todos.date >= #{Time.now.strftime("%Y%m%d").to_i})"
        
      base.has_many :expired_todos, :class_name => 'Todo', :foreign_key => "creator_id",
        :conditions => "todos.completed is not true and todos.date < #{Time.now.strftime("%Y%m%d").to_i}"
        
      base.has_many :completed_todos, :class_name => 'Todo', :foreign_key => "creator_id",
        :conditions => "todos.completed is true"
    end
  end
  
end
