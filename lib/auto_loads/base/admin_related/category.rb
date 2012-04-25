class Category < BuildDatabaseAbstract
  acts_as_nested_set

  has_many :media_files

  validates :name, :presence => true, :uniqueness => true

  default_scope order("created_at ASC")

  def save_as_child_of(parent)
    self.transaction do
      return false unless self.save
      self.move_to_child_of(parent)
      raise ActiveRecord::Rollback, "分类最大不能超过三级" if self.depth > 2
      true
    end
  end

  def has_max_depth?
    self.depth & self.depth >= 2 
  end
end
