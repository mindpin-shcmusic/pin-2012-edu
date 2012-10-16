class CreateCourseSurvey2Records < ActiveRecord::Migration
  def change
    create_table :course_survey_2_records do |t|
      t.integer  :course_survey_id
      t.string :attend_class
      t.text :attend_class_reason
      t.string :interesting_level
      t.string :keywords
      t.string :understand_level
      t.text :student_question
      t.text :student_response

      t.timestamps
    end
  end
end
