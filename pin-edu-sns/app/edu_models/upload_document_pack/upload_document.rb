class UploadDocument < ActiveRecord::Base
  KIND_TEXT  = 'TEXT'
  KIND_WORD  = 'WORD'
  KIND_EXCEL = 'EXCEL'

  belongs_to :file_entity

  belongs_to :dir,
             :class_name  => 'UploadDocumentDir',
             :foreign_key => 'dir_id'

  scope :kind_file, where('kind = ? or kind = ?', KIND_WORD, KIND_EXCEL)
  scope :kind_text, where('kind = ?', KIND_TEXT)
  scope :root_documents, where('dir_id = 0')

  def self.create_by_upload(params)
    file_name = params[:file_name]
    ext_name = file_name.split('.')[-1]
    kind = KIND_WORD if ext_name == 'doc' # 可能还有xdoc
    kind = KIND_EXCEL if ext_name == 'xls'

    params[:title] = file_name
    params[:kind] = kind

    return UploadDocument.create(params)
  end

  def is_file?
    self.kind == KIND_WORD || self.kind == KIND_EXCEL
  end

  def is_text?
    self.kind == KIND_TEXT
  end

end
