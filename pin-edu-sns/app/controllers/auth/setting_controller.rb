# -*- coding: utf-8 -*-
class Auth::SettingController <  ApplicationController
  before_filter :login_required

  # 基本信息
  def base
  end

    # 修改基本信息
  def base_submit
    @user= current_user

    @user.sign = params[:sign]
    @user.name = params[:name]
    if @user.save
      flash[:success] = "用户信息修改成功"
    else
      flash[:error] = get_flash_error(@user)
    end
    return redirect_to :action => :base
  end

  # -------------- 密码部分
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

  # -------------- 头像部分

  # 头像
  def avatar;end

  def temp_avatar
    send_data open(FileEntity.find(params[:entity_id]).attach.path, 'rb').read
  end

  # 修改头像 - 上传原始头像
  def avatar_submit_raw
    adpater = UserAvatarAdpater.new(current_user, params[:logo])
    
    @file_entity_id  = adpater.file_entity.id.to_s
    @temp_image_size = adpater.temp_image_size
    @temp_image_url  = adpater.temp_image_url

    render :template => '/auth/setting/crop_avatar'
  rescue Exception => ex
    p ex.message
    puts ex.backtrace * '\n'
    #flash[:error] = ex.to_json
    redirect_to :action => :avatar
  end
  
  # 修改头像 - 裁切原始头像并保存到云
  def avatar_submit_crop
    UserAvatarAdpater.crop_logo(current_user, params[:x], params[:y], params[:w], params[:h], params[:file_entity_id])
    redirect_to :action => :avatar
  rescue Exception => ex
    p ex.message
    puts ex.backtrace * '\n'
    flash[:error] = ex.message
    return redirect_to :action => :avatar
  end
  
end
