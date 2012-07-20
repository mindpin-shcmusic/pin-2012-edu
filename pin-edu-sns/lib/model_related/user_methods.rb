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
  
end
