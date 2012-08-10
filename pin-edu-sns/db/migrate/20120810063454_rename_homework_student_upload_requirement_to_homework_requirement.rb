class RenameHomeworkStudentUploadRequirementToHomeworkRequirement < ActiveRecord::Migration
  def change
    rename_table :homework_student_upload_requirements, :homework_requirements
  end
end
