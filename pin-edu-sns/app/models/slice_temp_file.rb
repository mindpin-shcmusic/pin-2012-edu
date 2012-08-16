class SliceTempFile < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"

  validates :creator_id, 
            :entry_file_name, 
            :real_file_name, 
            :entry_file_size, 
            :saved_size, 
            :presence => true

  before_validation(:on => :create) do |slice_temp_file|
    slice_temp_file.saved_size = 0
  end

  # 根据参数创建一个新的并返回
  def self.create_by_params(file_name,file_size, creator)
    self.create(
      :real_file_name  => file_name,
      :entry_file_name => get_randstr_filename(file_name),
      :entry_file_size => file_size,
      :creator         => creator
    )
  end
  
  # 获取一个文件的 MD5
  def self.get_md5(path)
    `md5sum '#{path}' |cut -d ' ' -f 1`.gsub("\n","")
  end

  def self.get_from_blob(creator, file_name, file_size, blob)
    md5 = self.get_md5(blob.path)
    self.where(
      :real_file_name  => file_name,
      :entry_file_size => file_size,
      :creator_id      => creator.id,
      :first_blob_md5  => md5
    ).first
  end

  # 保存文件片段
  def save_new_blob(file_blob)
    if saved_size == 0
      # 计算第一段 MD5
      first_blob_md5 = self.class.get_md5(file_blob.path)
      file_blob_size = file_blob.size
      # 创建结果文件
      FileUtils.mv(file_blob.path,file_path)
      # 修改字段
      self.saved_size += file_blob_size
      self.first_blob_md5 = first_blob_md5
      self.save
      return
    end

    file_blob_size = file_blob.size
    # `cat '#{file_blob.path}' >> '#{file_path}'`
    File.open(file_path,"a") do |src_f|
      File.open(file_blob,'r') do |f|
        src_f << f.read
      end
    end

    self.saved_size += file_blob_size
    self.save
  end

  def remove_files
    FileUtils.rm_r(blob_dir)
  end

  def build_file_entity
    file = File.new(file_path,"r")
    file_entity = FileEntity.create(:merged => true, :attach => file)

    self.remove_files
    self.destroy
    if file_entity.is_video?
      file_entity.into_video_encode_queue
    end
    file_entity
  end

  private
  # 所有文件片段是否全部上传完毕
  def is_complete_upload?
    self.saved_size >= self.entry_file_size
  end

  # 当前 slice_temp_file 的 文件片段的存放路径
  def blob_dir
    dir = File.join(R::SLICE_TEMP_FILE_ATTACHED_DIR, self.id.to_s)
    FileUtils.mkdir_p(dir)
    dir
  end

  # 合并后的 slice_temp_file 文件的存放的位置
  def file_path 
    File.join(blob_dir, self.entry_file_name)
  end
end

