class CreateStudentScores < ActiveRecord::Migration
  def change
    create_table :course_student_scores do |t|
      t.integer :course_student_assign_id
      t.integer :performance_score
      t.integer :exam_score
      t.integer :general_score
      t.string  :remark
    end
  end
end
