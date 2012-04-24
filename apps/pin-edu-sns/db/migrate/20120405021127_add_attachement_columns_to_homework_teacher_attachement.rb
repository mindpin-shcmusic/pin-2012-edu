# -*- encoding : utf-8 -*-
class AddAttachementColumnsToHomeworkTeacherAttachement < ActiveRecord::Migration
  def self.up
    add_column :homework_teacher_attachements, :attachement_file_name,    :string
    add_column :homework_teacher_attachements, :attachement_content_type, :string
    add_column :homework_teacher_attachements, :attachement_file_size,    :integer
    add_column :homework_teacher_attachements, :attachement_updated_at,   :datetime
  end

  def self.down
    remove_column :homework_teacher_attachements, :attachement_file_name
    remove_column :homework_teacher_attachements, :attachement_content_type
    remove_column :homework_teacher_attachements, :attachement_file_size
    remove_column :homework_teacher_attachements, :attachement_updated_at
  end
end
