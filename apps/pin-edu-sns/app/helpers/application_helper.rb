module ApplicationHelper
  include MindpinHelperBase

  def display_notifier
    if any_notifiction? || any_message?
      return
    end
    'display:none;'
  end

  def display_notification_notifier
    display any_notifiction?
  end

  def display_message_notifier
    display any_message?
  end

  def notification_count(user)
    Notification.unread(user).count
  end

  def message_count(user)
    UserTipMessage.count(user)
  end

  protected

  def display(condition)
    if condition
      return
    end
    'display:none;'
  end

  def any_message?
    UserTipMessage.count(current_user) != 0
  end

  def any_notifiction?
    Notification.any_unread?(current_user)
  end
end
