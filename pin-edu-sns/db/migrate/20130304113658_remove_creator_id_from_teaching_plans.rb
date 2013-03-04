class RemoveCreatorIdFromTeachingPlans < ActiveRecord::Migration
  def change
    remove_column :teaching_plans, :creator_id
  end
end
