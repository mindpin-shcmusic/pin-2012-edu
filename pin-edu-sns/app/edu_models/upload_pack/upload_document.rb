class UploadDocument < ActiveRecord::Base
  belongs_to :dir,
          :class_name  => 'UploadDocumentDir',
          :foreign_key => 'dir_id'

  scope :dir_files, lambda { |dir_id| where("dir_id = ?", dir_id) }
end
