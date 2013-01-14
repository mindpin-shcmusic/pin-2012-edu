class AddContentToTeachingPlans < ActiveRecord::Migration
  def change
    add_column :teaching_plans, :content, :text
  end
end
