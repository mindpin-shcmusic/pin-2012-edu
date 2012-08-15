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

  def self.dynatree_data(activated_category)
    expand_categories = []
    activate = false
    if !activated_category.blank?
      expand_categories = activated_category.self_and_ancestors
    else
      activate = true
    end
    [{
      :title => "无分类", :id => -1, :activate => activate,:expand => true,
      :children => sub_dynatree_data(Category.roots,activated_category,expand_categories) 
    }]
  end

  def self.sub_dynatree_data(categories,activated_category,expand_categories)
    categories.map do |category|
      children = category.children
      hash = {:title=>category.name,:id=>category.id}
      if !children.blank?
        hash[:children] = sub_dynatree_data(children,activated_category,expand_categories)
        hash[:isFolder] = true
      end
      hash[:expand] = true if expand_categories.include?(category)
      hash[:activate] = true if category == activated_category
      hash
    end
  end
end
