class ChangeMentorCourseFromMentorStudents < ActiveRecord::Migration
  def change
    add_column :mentor_students, :mentor_course1, :integer
    add_column :mentor_students, :mentor_course2, :integer
    add_column :mentor_students, :mentor_course3, :integer

    remove_column :mentor_students, :course1
    remove_column :mentor_students, :course2
    remove_column :mentor_students, :course3

    remove_column :mentor_students, :teacher1
    remove_column :mentor_students, :teacher2
    remove_column :mentor_students, :teacher3
  end
end
