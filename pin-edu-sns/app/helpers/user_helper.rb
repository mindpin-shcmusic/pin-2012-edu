module UserHelper
  def current_user_title
    return '老师' if current_user.is_teacher?
    return '同学' if current_user.is_student?
  end
end