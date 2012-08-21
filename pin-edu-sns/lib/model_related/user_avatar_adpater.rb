# -*- coding: utf-8 -*-
class UserAvatarAdpater
  
  def initialize(user, raw_file)
    @raw_file = raw_file

    user_id_str = user.id.to_s

    @temp_file_entity = FileEntity.create :attach => raw_file
    # @temp_file_dir  = File.join(TEMP_FILE_BASE_DIR, user_id_str)
    # @temp_file_name = File.join(@temp_file_dir, 'avatar_tmp')

    @temp_file_url    = "/auth/setting/temp_avatar?entity_id=#{@temp_file_entity.id}"
  end
  
  # 获取临时文件图片的宽高hash
  def temp_image_size
    temp_file = File.new(@temp_file_entity.attach.path)
    image = Magick::Image::read(temp_file).first

    return {:height=>image.rows, :width=>image.columns}
  end

  def file_entity
    @temp_file_entity
  end

  def temp_image_url
    @temp_file_url
  end

  # -------------------------------------
  
  def self.crop_logo(user, x1, y1, width, height, file_entity_id)
    # user_id_str = user.id.to_s
    # temp_file_dir  = File.join(TEMP_FILE_BASE_DIR, user_id_str)
    # temp_file_name = File.join(temp_file_dir, 'avatar_tmp')
    file_entity = FileEntity.find(file_entity_id)
    temp_file = File.new(file_entity.attach.path)

    # 读取临时文件，裁切，转换格式
    img = Magick::Image::read(temp_file).first
    img.crop!(x1.to_i, y1.to_i, width.to_i, height.to_i, true)
    img.format = 'PNG'

    # 写第二个临时文件，裁切好的PNG文件
    croped_file = Tempfile.new(["user-#{user.id}", 'png'])
    img.write croped_file.path

    # 赋值给user.logo (保存到云)
    user.update_attributes(:logo=>croped_file)

    # 移除临时文件
    croped_file.close
    croped_file.unlink
    file_entity.destroy
  end

end
