class AddIsRemovedToVariousModels < ActiveRecord::Migration
  def change
    add_column :courses, :is_removed, :boolean, :default => false
    add_column :teams, :is_removed, :boolean, :default => false
    add_column :teachers, :is_removed, :boolean, :default => false
    add_column :students, :is_removed, :boolean, :default => false
    add_column :categories, :is_removed, :boolean, :default => false
  end
end
