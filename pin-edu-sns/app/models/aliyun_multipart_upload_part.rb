class AliyunMultipartUploadPart < ActiveRecord::Base
  belongs_to :file_entity

  validates :file_entity_id, :presence => true
  validates :upload_id, :presence => true, :uniqueness => {:scope => :file_entity_id}
  validates :part_num,  :presence => true, :uniqueness => {:scope => [:file_entity_id,:upload_id]}
  validates :md5, :presence => true
end
