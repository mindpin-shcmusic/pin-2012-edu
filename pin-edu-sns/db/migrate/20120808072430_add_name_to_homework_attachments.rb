class AddNameToHomeworkAttachments < ActiveRecord::Migration
  def change
    add_column :homework_teacher_attachments, :name, :string
    add_column :homework_student_uploads, :name, :string
  end
end
