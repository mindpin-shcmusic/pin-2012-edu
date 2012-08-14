class AddTeacherUserIdAndStudentUserIdToCourseRelateteamRelated < ActiveRecord::Migration
  def change
    remove_column :teams, :teacher_id
    add_column    :teams, :teacher_user_id, :integer
    remove_column :team_students, :student_id
    add_column    :team_students, :student_user_id, :integer
  end
end
