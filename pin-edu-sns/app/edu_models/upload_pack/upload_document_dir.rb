class UploadDocumentDir < ActiveRecord::Base
  has_many   :upload_document_dirs,
             :foreign_key => 'dir_id'

  scope :sub_dirs, lambda { |dir_id| where("dir_id = ?", dir_id) }
  scope :web_order, order('id DESC')

  validates :name, :format => { :with => /^([A-Za-z0-9一-龥\-\_\.]+)$/,
    :message => "请填写正确的文件名" }
  validate :validate_folder_name


  class IncorrectFolderNameError < Exception; end;

  include ModelRemovable
  include Paginated
end
