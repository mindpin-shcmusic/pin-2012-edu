# -*- coding: utf-8 -*-
class Category < ActiveRecord::Base
  acts_as_nested_set

  has_many :media_files

  validates :name, :presence => true, :uniqueness => true

  default_scope order("created_at ASC")

  def media_file_count
    self.media_files.count
  end

  def media_files
    _ids = self.self_and_descendants.map do |category|
      category.id
    end
    MediaFile.where("category_id in (?)", _ids)
  end

  def media_files_with_user(user)
    self.media_files.where("creator_id = ?", user.id)
  end

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

  include Removable

end
