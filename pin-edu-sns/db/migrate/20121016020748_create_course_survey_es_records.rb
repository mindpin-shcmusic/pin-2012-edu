class CreateCourseSurveyEsRecords < ActiveRecord::Migration
  def up
    drop_table :course_survey_2_records

    create_table :course_survey_es_records do |t|
      t.integer :course_survey_id
      t.integer :student_user_id
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
