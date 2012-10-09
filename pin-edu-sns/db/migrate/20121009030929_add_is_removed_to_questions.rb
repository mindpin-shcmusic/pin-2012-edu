class AddIsRemovedToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :is_removed, :boolean, :default => false
  end
end
