class CreateCourseScoreLists < ActiveRecord::Migration
  def change
    create_table :course_score_lists do |t|
      t.integer :course_id
      t.integer :teacher_user_id
      t.string  :semester_value
      t.string  :title

      t.timestamp
    end

  end
end
