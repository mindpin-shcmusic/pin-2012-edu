$ ->
  jug = new Juggernaut
  user_id = $('meta[current-user-id]').attr 'current-user-id'
  $notification_el = $ '.notification.empty'
  $notifier = $ '.notifier'
  $notification_notifier = $ '.notifier .notification-notifier'
  $message_notifier = $ '.notifier .message-notifier'

  $unread_count = $ '.notification-unread-count'

  $('.remove').live 'click', ->
    $(this).parent().fadeOut()

  jug.subscribe "notification-count-user-#{user_id}", (data)->
    count = data.notifications
    $unread_count.text count
    $('.notification-notifier').data 'count', count
    message_count = $('.message-notifier').data 'count'

    if count > 0
      $unread_count.fadeIn()
      $notifier.show()
      $notification_notifier.find('.content')
                            .text("#{count}条未读通知")
      $notification_notifier.fadeIn()
    else
      $unread_count.fadeOut()
      $notification_notifier.fadeOut()
      $notifier.hide() if message_count <= 0

  jug.subscribe "message-count-user-#{user_id}", (data)->
    console.log data
    count = data.messages
    $('.message-notifier').data 'count', count
    notification_count = $('.notification-notifier').data 'count'

    if count > 0
      $notifier.show()
      $message_notifier.find('.content')
                       .text("#{count}条提示消息")
      $message_notifier.fadeIn()
    else
      $message_notifier.fadeOut()
      $notifier.hide() if notification_count <= 0

  jug.subscribe 'notification-read-all-user-' + user_id, (data)->
    console.log data
    $('.notifications .notification').addClass 'read'

  jug.subscribe 'incoming-notification-user-' + user_id, (data)->
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
