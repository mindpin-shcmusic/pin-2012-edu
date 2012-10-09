class ChangeTeacherIdToTeacherUserId < ActiveRecord::Migration
  def change
    rename_column :questions, :teacher_id, :teacher_user_id
  end
end
