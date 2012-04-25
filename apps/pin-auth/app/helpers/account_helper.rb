module AccountHelper
  # 尝试返回尺寸为200的user头像，如果没有（头像更新于9月20日前的，则返回:medium的头像 96x96）
  def user_avatar_big(user)
    avatar user, :large
  end
end
