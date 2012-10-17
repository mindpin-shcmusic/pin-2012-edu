class AddCourseTeacherToCourseSurveys < ActiveRecord::Migration
  def change
    add_column :course_surveys, :course_teacher_id, :integer
  end
end
