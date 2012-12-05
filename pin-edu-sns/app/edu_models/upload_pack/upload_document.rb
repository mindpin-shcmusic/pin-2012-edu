class UploadDocument < ActiveRecord::Base
  belongs_to :dir,
          :class_name  => 'UploadDocumentDir',
          :foreign_key => 'dir_id'
end
