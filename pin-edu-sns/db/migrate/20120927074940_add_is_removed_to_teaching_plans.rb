class AddIsRemovedToTeachingPlans < ActiveRecord::Migration
  def change
    add_column :teaching_plans, :is_removed, :boolean
  end
end
