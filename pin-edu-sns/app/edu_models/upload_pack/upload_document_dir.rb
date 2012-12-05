class UploadDocumentDir < ActiveRecord::Base
  has_many   :upload_document_dirs,
             :foreign_key => 'dir_id'

  scope :root_res, where(:dir_id => 0)
  scope :web_order, order('id DESC')



  include ModelRemovable
  include Paginated
end
