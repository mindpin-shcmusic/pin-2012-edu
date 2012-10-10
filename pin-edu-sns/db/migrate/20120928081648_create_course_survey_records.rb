class CreateCourseSurveyRecords < ActiveRecord::Migration
  def change
    create_table :course_survey_records do |t|
      t.integer :course_survey_id
      t.integer :student_user_id
      t.boolean :on_off_class
      t.boolean :checking_institution
      t.boolean :class_order
      t.string :prepare_situation
      t.string :teaching_level
      t.string :teacher_morality
      t.string :class_content
      t.string :knowledge_level
      t.string :teaching_schedule
      t.string :teaching_interact
      t.string :board_writing_quality
      t.string :has_courseware
      t.string :courseware_quality
      t.string :speak_level
      t.string :study_result
      t.string :teaching_result
      t.string :result_reason
      t.text :suggestion

      t.timestamps
    end
  end
end
