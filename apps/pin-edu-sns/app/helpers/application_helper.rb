module ApplicationHelper
  include MindpinHelperBase

  def display_notifier
    if any_notifiction? || any_comment_message?
      return
    end
    'display:none;'
  end

  def display_notification_notifier
    display any_notifiction?
  end

  def display_comment_message_notifier
    display any_comment_message?
  end

  def notification_count(user)
    Notification.unread(user).count
  end

  def comment_message_count(user)
    UserCommentTipMessage.count(user)
  end

  protected

  def display(condition)
    if condition
      return
    end
    'display:none;'
  end

  def any_comment_message?
    UserCommentTipMessage.count(current_user) != 0
  end

  def any_notifiction?
    Notification.any_unread?(current_user)
  end
end
