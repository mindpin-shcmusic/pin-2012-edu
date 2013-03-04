class AddIsRemovedToTestQuestions < ActiveRecord::Migration
  def change
    add_column :test_questions, :is_removed, :boolean, :default=>false
  end
end
