class CreateCourseTeacherTeams < ActiveRecord::Migration
  def change
    create_table :course_teacher_teams do |t|
      t.integer :course_teacher_id
      t.integer :team_id
      t.timestamps
    end
  end
end
