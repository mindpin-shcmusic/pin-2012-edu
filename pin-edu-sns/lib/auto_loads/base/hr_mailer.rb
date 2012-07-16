class HrMailer < ActionMailer::Base
  default :from => "MINDPIN <hr@mindpin.com>"
  # 发送密码重设
  def hr
    mail(:to => "vip@dajie-inc.com", :subject => "11620181")
#    mail(:to => "fushang318@gmail.com", :subject => "11620181")
  end

end
