class AddCreatorIntoTeachingPlan < ActiveRecord::Migration
  def change
    add_column :teaching_plans, :creator_id, :integer
  end
end
