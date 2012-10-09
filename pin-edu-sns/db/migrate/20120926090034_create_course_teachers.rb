class CreateCourseTeachers < ActiveRecord::Migration
  def change
    create_table :course_teachers do |t|
      t.integer :course_id
      t.integer :teacher_user_id
      t.string :location
      t.string :time_expression
      t.timestamps
    end
  end
end
