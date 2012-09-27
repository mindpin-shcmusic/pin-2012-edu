class ChangeCoursesColumns < ActiveRecord::Migration
  def change
    remove_column :courses, :department
    remove_column :courses, :location
    remove_column :courses, :teacher_user_id
  end
end
