class RemoveTeacherUserIdAndSemesterValueFromTeachingPlans < ActiveRecord::Migration
  def change
    remove_column :teaching_plans, :teacher_user_id, :semester_value
  end
end
