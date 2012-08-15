class AddTeacherUserIdAndStudentUserIdToCourseRelated < ActiveRecord::Migration
  def change
    remove_column :courses, :teacher_id
    add_column    :courses, :teacher_user_id, :integer
    remove_column :course_students, :student_id
    add_column    :course_students, :student_user_id, :integer
  end
end
