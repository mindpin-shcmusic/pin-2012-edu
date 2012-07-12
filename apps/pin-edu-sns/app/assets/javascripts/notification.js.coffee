$ ->
  jug                      = new Juggernaut
  notification_notifier    = new NotificationNotifier('.notification-notifier')
  comment_message_notifier = new CommentMessageNotifier('.comment-message-notifier')
  unread_counter           = new Counter('.notification-unread-count', notification_notifier)
  user_id                  = $('meta[current-user-id]').attr 'current-user-id'
  $notification_el         = $ '.notification.empty'

  $('.remove').live 'click', ->
    $(this).parent().fadeOut()

  notification_notifier.subscribe    jug, "notification-count-user-#{user_id}"

  comment_message_notifier.subscribe jug, "comment-message-count-user-#{user_id}"

  jug.subscribe "notification-read-all-user-#{user_id}", (data)->
    console.log data
    $('.notifications .notification').addClass 'read'

  jug.subscribe "incoming-notification-user-#{user_id}", (data)->
    make_notification data

  make_notification = (obj)->
    $el        = $notification_el.clone()
    time_text  = $el.find('.time').text()
    remove_url = $el.find('.remove').attr 'href'

    $el.removeClass('read empty')
    $el.find('.content').html obj.content
    $el.find('.time').html time_text + obj.created_at
    $el.find('.remove').attr 'href', remove_url + obj.id

    $('.notifications').prepend($el)
    $el.fadeIn()
