class ChangeFromCourseSurveyRecords < ActiveRecord::Migration
  def change
    change_column :course_survey_records, :on_off_class, :string
    change_column :course_survey_records, :checking_institution, :string
    change_column :course_survey_records, :class_order, :string
  end
end
