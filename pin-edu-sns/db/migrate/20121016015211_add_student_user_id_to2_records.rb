class AddStudentUserIdTo2Records < ActiveRecord::Migration
  def change
    add_column :course_survey_2_records, :student_user_id, :integer
  end
end
