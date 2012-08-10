# -*- coding: utf-8 -*-
class Category < ActiveRecord::Base
  acts_as_nested_set

  validates :name, :presence => true
  default_scope order("created_at ASC")

  include ModelRemovable

  def self.import_from_yaml(file)
    text = file.read
    text = text.gb2312_to_utf8 if !text.utf8?
    hash = YAML.load(text)
    ActiveRecord::Base.transaction do
      categories = _import_from_yaml_by_hash(hash)
      categories.each{|c|c.move_to_root}
    end
  end

  def self._import_from_yaml_by_hash(child_hash)
    return [] if child_hash.blank?

    child_hash.map do |parent_name,child_name_hash|
      categories = self._import_from_yaml_by_hash(child_name_hash)
      parent_category = Category.create(:name=>parent_name)
      categories.each{|c|c.move_to_child_of(parent_category)}
      parent_category
    end
  end

  def remove_tree
    self.children.each do |category|
      category.remove_tree
    end
    self.remove
  end
end
