class ChangeCourseTeacherIdFromCourseSurveys < ActiveRecord::Migration
  def change
    remove_column :course_surveys, :course_teacher_id

    add_column :course_surveys, :course_id, :integer
    add_column :course_surveys, :teacher_user_id, :integer
    add_column :course_surveys, :semester_value, :string
  end
end
