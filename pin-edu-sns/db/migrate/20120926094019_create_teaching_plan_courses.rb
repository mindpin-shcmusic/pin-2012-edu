class CreateTeachingPlanCourses < ActiveRecord::Migration
  def change
    create_table :teaching_plan_courses do |t|
      t.integer :teaching_plan_id
      t.integer :course_id
      t.timestamps
    end
  end
end
