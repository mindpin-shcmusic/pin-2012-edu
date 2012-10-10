class AddHasAnsweredToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :has_answered, :boolean, :default => false
  end
end
