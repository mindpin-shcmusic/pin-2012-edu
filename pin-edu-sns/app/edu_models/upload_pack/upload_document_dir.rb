class UploadDocumentDir < ActiveRecord::Base
  has_many   :upload_document_dirs,
             :foreign_key => 'dir_id'

  scope :sub_dirs, lambda { |dir_id| where("dir_id = ?", dir_id) }
  scope :web_order, order('id DESC')



  include ModelRemovable
  include Paginated
end
