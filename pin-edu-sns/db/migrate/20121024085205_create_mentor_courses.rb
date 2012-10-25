class CreateMentorCourses < ActiveRecord::Migration
  def change
    create_table :mentor_courses do |t|
      t.integer :teacher_user_id
      t.string :course

      t.timestamps
    end
  end
end
