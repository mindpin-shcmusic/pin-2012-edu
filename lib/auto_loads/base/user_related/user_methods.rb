module UserMethods
  ADMIN_USER_EMAILS = case Rails.env
    when "development"
    ["ben7th@126.com"]
    when "test"
    ["ben7th@126.com"]
    when "production"
    [
        "ben7th@sina.com",
        "4820357@qq.com",
        "sophia.njtu@gmail.com"
    ]
  end
  
  AVATAR_PATH = "/:class/:attachment/:id/:style/:basename.:extension"
  AVATAR_URL  = "http://storage.aliyun.com/#{OssManager::CONFIG["bucket"]}/:class/:attachment/:id/:style/:basename.:extension"
  
  
  def self.included(base)
    base.set_table_name("users")
    # 在线状态记录
    base.has_one :online_record,:dependent => :destroy
    base.send(:extend,  ClassMethods)
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
      :default_url   => pin_url_for('pin-auth',"/images/default_avatars/:style.png"),
      :default_style => :normal
    
    # 校验部分
    # 不能为空的有：用户名，登录名，电子邮箱
    # 不能重复的有：登录名，电子邮箱
    # 两次密码输入必须一样，电子邮箱格式必须正确
    # 密码允许为空，但是如果输入了，就必须是4-32
    base.validates_presence_of :email
    base.validates_uniqueness_of :email,:case_sensitive=>false
    base.validates_format_of :email,:with=>/^([A-Za-z0-9_]+)([\.\-\+][A-Za-z0-9_]+)*(\@[A-Za-z0-9_]+)([\.\-][A-Za-z0-9_]+)*(\.[A-Za-z0-9_]+)$/
    # 用户名
    # 用户名：是2-20位的中文或者英文，但是两者不能混用
    # 从可以是纯中文或纯英文的限制
    # 改为可以是中英文混写
    #base.validates_format_of :name,:with=>/^([A-Za-z0-9]{1}[A-Za-z0-9_]+)$|^([一-龥]+)$/
    base.validates_presence_of :name
    base.validates_format_of :name,:with=>/^([A-Za-z0-9一-龥]+)$/
    base.validates_length_of :name, :in => 2..20
    base.validates_uniqueness_of :name,:case_sensitive=>false
    
    base.validates_presence_of :password,:on=>:create
    base.validates_length_of :password, :in => 4..32, :allow_blank=>true
    
    base.validates_presence_of :password_confirmation,:on=>:create
    base.send(:attr_accessor,:password_confirmation)
    base.validates_confirmation_of :password
  end
  
  module ClassMethods
    # 根据传入的邮箱名和密码进行用户验证
    def authenticate(email, password)
      user = User.find_by_email(email)
      if !!user
        expected_password = encrypted_password(password, user.salt)
        if user.hashed_password != expected_password
          user = nil
        end
      end
      user
    end
    
    # 电子邮箱或用户名 认证
    def authenticate2(email_or_name, password)
      user = self.authenticate(email_or_name, password)
      if user.blank?
        User.find_all_by_name(email_or_name).each do |u|
          expected_password = encrypted_password(password, u.salt)
          if u.hashed_password == expected_password
            return u
          end
        end
      end
      return user
    end
    
    # 验证cookies令牌
    def authenticate_cookies_token(token)
      t = token.split(':')
      user = User.find_by_email(t[0])
      if user
        if t[2] != hashed_token_string(user.email, user.hashed_password)
          user=nil
        end
      end
      user
    end
    
    # 使用SHA1算法，根据内部密钥和明文密码计算加密后的密码
    def encrypted_password(password, salt)
      Digest::SHA1.hexdigest(password + 'jerry_sun' + salt)
    end
    
    # 使用SHA1算法生成令牌字符串
    def hashed_token_string(name, hashed_password)
      Digest::SHA1.hexdigest(name + hashed_password + 'onlyecho')
    end
  end
  
  def validate_on_create
    if !self.email.gsub("@mindpin.com").to_a.blank?
      errors.add(:email,"邮箱格式不符规范")
    end
  end
  
  def validate_on_update
    if !self.email.gsub("@mindpin.com").to_a.blank?
      errors.add(:email,"邮箱格式不符规范")
    end
  end
  
  ###
  # 创建cookies登录令牌
  def create_cookies_token(expire)
    value=self.email+':'+expire.to_s+':'+User.hashed_token_string(self.email,self.hashed_password)
    {
      :value   => value,
      :expires => expire.days.from_now,
      :domain  => Rails.application.config.session_options[:domain]
    }
  end
  
  def password
    @password
  end
  
  # 根据传入的明文密码，创建内部密钥并计算密文密码
  def password=(pwd)
    @password=pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password=User.encrypted_password(self.password,self.salt)
  end
  
  # 密码重设，并发送邮件
  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
    self.save(:validate => false)
    Mailer.forgotpassword(self).deliver
  end
  
  # 该用户是否激活？（邮件激活，目前未启用）
  def activated?
    !activated_at.blank?
  end
  
  # 该用户是否admin用户？
  def is_admin_user?
    ADMIN_USER_EMAILS.include?(self.email)
  end
  
  # 该用户是否admin用户？ 同 is_admin_user?
  def is_admin?
    is_admin_user?
  end
  
  def change_password(old_pass,new_pass,new_pass_confirmation)
    raise "请输入旧密码" if old_pass.blank?
    raise "请输入新密码" if new_pass.blank?
    raise "请输入确认新密码" if new_pass_confirmation.blank?
    raise "新密码和确认新密码输入不相同" if new_pass_confirmation != new_pass
    user = User.authenticate(self.email,old_pass)
    raise "旧密码输入错误" if self.id != user.id
    user.password=new_pass
    user.password_confirmation=new_pass_confirmation
    user.save!
  end
  
  protected
  def make_password_reset_code
    self.reset_password_code = Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by{rand}.join)
    self.reset_password_code_until = Time.now.next_year
  end
  
  # 随机生成内部密钥
  private
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
end
