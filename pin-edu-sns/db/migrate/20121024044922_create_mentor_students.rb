class CreateMentorStudents < ActiveRecord::Migration
  def change
    create_table :mentor_students do |t|
      t.integer :mentor_note_id
      t.integer :user_id
      
      t.string  :course1
      t.string  :teacher1
      t.string  :course2
      t.string  :teacher2
      t.string  :course3
      t.string  :teacher3

      t.timestamps
    end
  end
end
