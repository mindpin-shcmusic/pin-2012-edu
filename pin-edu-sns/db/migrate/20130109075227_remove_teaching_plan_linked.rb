class RemoveTeachingPlanLinked < ActiveRecord::Migration
  def change
    remove_column :teams, :teaching_plan_id
    drop_table :teaching_plan_students
    drop_table :teaching_plan_courses
  end

end
