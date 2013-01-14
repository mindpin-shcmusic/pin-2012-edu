class RemoveTeachingPlanLinked < ActiveRecord::Migration
  def change
    drop_table :teaching_plan_students
    drop_table :teaching_plan_courses
  end

end
