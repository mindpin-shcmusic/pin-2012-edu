module UserAvatarMethods
  AVATAR_PATH = "/:class/:attachment/:id/:style/:basename.:extension"
  AVATAR_URL  = "http://storage.aliyun.com/#{OssManager::CONFIG["bucket"]}/:class/:attachment/:id/:style/:basename.:extension"
  def self.included(base)
    base.has_attached_file :logo,
      :styles => {
        :large  => '200x200#',
        :medium => '96x96#',
        :normal => '48x48#',
        :tiny   => '32x32#',
        :mini   => '24x24#'
      },
      :storage => :oss,
      :path => AVATAR_PATH,
      :url  => AVATAR_URL,
      :default_url   => '/default_avatars/:style.png',
      :default_style => :normal
  end
end