class Category < BuildDatabaseAbstract
  acts_as_nested_set

  validates :name, :presence => true, :uniqueness => true

  def save_as_child_of(parent)
    self.transaction do
      self.save
      self.move_to_child_of(parent)
      if self.depth > 2
        raise ActiveRecord::Rollback, "分类不能超过三级"
      else
        true
      end
    end
  end

  def has_max_depth?
    self.depth & self.depth >= 2 
  end
end
