class CreateStudentScores < ActiveRecord::Migration
  def change
    create_table :course_score_records do |t|
      t.integer :course_score_list_id
      t.integer :student_user_id
      t.integer :performance_score
      t.integer :exam_score
      t.string  :remark

    end
  end
end
