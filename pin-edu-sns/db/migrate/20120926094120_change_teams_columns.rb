class ChangeTeamsColumns < ActiveRecord::Migration
  def change
    remove_column :teams, :teacher_user_id
    add_column    :teams, :teaching_plan_id, :integer
    add_column    :teams, :course_teacher_team_id, :integer
  end
end
