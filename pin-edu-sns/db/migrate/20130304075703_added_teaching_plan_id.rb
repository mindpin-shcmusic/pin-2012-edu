class AddedTeachingPlanId < ActiveRecord::Migration
  def change
    add_column    :homeworks, :teaching_plan_id, :integer
    remove_column :homeworks, :course_id
  end
end
