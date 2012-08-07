class FixHomeworkTeacherAttachmentTableName < ActiveRecord::Migration
  def change
    rename_table :homework_teacher_attachements, :homework_teacher_attachments
  end
end
