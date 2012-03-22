class Notification < BuildDatabaseAbstract
  # --- 模型关联
  belongs_to :user, :class_name => 'User'
  
  # --- 校验方法
  validates :user_id, :kind, :data, :presence => true
  
  def set_readed
    self.is_read = true
    self.save
  end
end
