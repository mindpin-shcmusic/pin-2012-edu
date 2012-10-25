class ChangeIntoStudentUserId < ActiveRecord::Migration
  def up
    rename_column :mentor_students, :user_id, :student_user_id
  end
end
