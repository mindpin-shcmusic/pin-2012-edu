# -*- coding: utf-8 -*-
class Auth::SettingController <  ApplicationController
  before_filter :login_required

  # 基本信息
  def base
  end

    # 修改基本信息
  def base_submit
    @user= current_user

      if !params[:old_password].blank?
        return redirect_error_info("请输入新密码") if params[:new_password].blank?

        if (params[:new_password_confirmation] != params[:new_password])
          return redirect_error_info("新密码和确认新密码输入不相同")
        end

        u = User.authenticate(current_user.email,params[:old_password])
        if u.blank? || u != @user
          return redirect_error_info("旧密码输入错误")
        end

        @user.password=params[:new_password]
        @user.password_confirmation=params[:new_password_confirmation]
      end

    @user.sign = params[:sign]
    @user.name = params[:name]
    if @user.save
      flash[:success] = "用户 #{@user.email}（#{@user.name}）的信息已经成功修改"
    else
      flash[:error] = get_flash_error(@user)
    end
    return redirect_to :action => :base
  end

  def redirect_error_info(error)
    flash[:error] = error
    redirect_to :action=>:base
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
