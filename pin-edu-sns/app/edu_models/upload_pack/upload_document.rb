class UploadDocument < ActiveRecord::Base
  belongs_to :file_entity
  
  belongs_to :dir,
          :class_name  => 'UploadDocumentDir',
          :foreign_key => 'dir_id'

  scope :dir_files, lambda { |dir_id| where("dir_id = ? and file_entity_id != 0", dir_id) }
  scope :dir_texts, lambda { |dir_id| where("dir_id = ?", dir_id) }
end
