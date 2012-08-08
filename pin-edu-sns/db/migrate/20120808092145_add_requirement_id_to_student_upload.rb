class AddRequirementIdToStudentUpload < ActiveRecord::Migration
  def change
    add_column :homework_student_uploads, :requirement_id, :integer
  end
end
