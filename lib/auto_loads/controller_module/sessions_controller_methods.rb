module SessionsControllerMethods
  # 登录
  def new
    return redirect_back_or_default(root_url) if logged_in?
    return render :layout=>'anonymous',:template=>'index/login'
  end
  
  def create
    self.current_user = User.authenticate2(params[:email], params[:password])
    site = 'pin-user-auth'
    if logged_in?
      after_logged_in()
      return redirect_to pin_url_for(site,'/')
    else
      flash[:error]="邮箱/密码不正确"
      return redirect_to pin_url_for(site,'/login')
    end
  end
  
  # 登出
  def destroy
    user = current_user
    
    if user
      reset_session_with_online_key()
      # 登出时销毁cookies令牌
      destroy_remember_me_cookie_token()
      destroy_online_record(user)
    end
    
    return redirect_to pin_url_for('pin-user-auth','/login')
  end
  
end
