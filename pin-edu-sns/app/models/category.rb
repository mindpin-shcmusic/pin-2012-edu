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

  def self.preload_dynatree(activated_category = nil)
    expand_categories = activated_category.blank? ? [] : activated_category.self_and_ancestors-[activated_category]
    activate = activated_category.blank?

    return [{
      :title => "无分类", :id => 0, :isFolder => true, :key => 0,
      :activate => activate, :expand => true, :isLazy => true,
      :children => _preload_sub_dynatree(Category.roots,activated_category,expand_categories) 
    }]

  end

  def self._preload_sub_dynatree(categories,activated_category,expand_categories)
    categories.map do |category|
      child_categories = category.children
      isLazy = !child_categories.blank?

      children = []
      expand = false

      if expand_categories.include?(category)
        children = _preload_sub_dynatree(child_categories,activated_category,expand_categories)
        expand = true
      end
      activate = (category == activated_category)

      {
        :title => category.name, :id => category.id, :key => category.id,
        :children => children, :isFolder => true, :isLazy => isLazy,
        :expand => expand, :activate => activate
      }
    end
  end

  def self.lazyload_sub_dynatree(category_id)
    if category_id.to_i == 0
      categories = Category.roots
    else
      categories = Category.find(category_id).children
    end

    categories.map do |category|
      isLazy = !category.children.blank?
      {
        :title => category.name, :id => category.id,
        :isFolder => true, :isLazy => isLazy, :key => category.id
      }
    end
  end
end
