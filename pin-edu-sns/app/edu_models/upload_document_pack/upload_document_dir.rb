class UploadDocumentDir < ActiveRecord::Base
  has_many :sub_dirs,
           :foreign_key => 'dir_id',
           :class_name => 'UploadDocumentDir'

  has_many :documents,
           :foreign_key => 'dir_id',
           :class_name => 'UploadDocument'

  default_scope order('id DESC')

  scope :root_dirs, where('dir_id = 0')

  validates :name, :format => { 
    :with => /^([A-Za-z0-9一-龥\-\_\.]+)$/,
    :message => "请填写正确的文件名" 
  }

  def self.get_by_id(id)
    return self.find(id) if id.to_i > 0
    return UploadDocumentDir::RootDir.new
  end

  include ModelRemovable
  include Paginated

  class RootDir
    def sub_dirs
      UploadDocumentDir.root_dirs
    end

    def documents
      UploadDocument.root_documents
    end
  end
end
