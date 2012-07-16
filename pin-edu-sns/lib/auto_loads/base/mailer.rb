class Mailer < ActionMailer::Base
  default :from => "MINDPIN社区 <noreply@mindpin.com>"
  # 发送密码重设
  def forgotpassword(user)
    @user = user
    mail(:to => user.email, :subject => "来自MINDPIN的密码重置邮件")
  end

end
