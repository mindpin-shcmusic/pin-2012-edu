class Admin::SettingController < ApplicationController
  layout 'admin'
  before_filter :login_required

  def password;end

  def password_submit
    @user = current_user
    u = User.authenticate(@user.email,params[:old_password])
    if u.blank? || u != @user
      flash[:error] = "旧密码输入错误"
      return redirect_to :action => :password
    end

    @user.password = params[:new_password]
    @user.password_confirmation = params[:new_password_confirmation]

    if @user.save
      flash[:success] = "密码修改成功"
    else
      flash[:error] = get_flash_error(@user)
    end
    redirect_to :action => :password
  end
end