$ ->
  jug = new Juggernaut
  user_id = $('meta[current-user-id]').attr 'current-user-id'
  $notification_el = $ '.notification.empty'
  $notifier        = $ '.notification-notifier'

  $unread_count = $ '.notification-unread-count'

  $('.remove').live 'click', ->
    $(this).parent().fadeOut()

  jug.subscribe 'notification-count-user-' + user_id, (data)->
    count = data.notifications
    console.log data, count
    $unread_count.text(count)
    if count > 0
      $unread_count.fadeIn()
      $notifier.text('未读通知' + count + '条').fadeIn()
    else
      $unread_count.fadeOut()
      $notifier.fadeOut()

  jug.subscribe 'notification-read-all-user-' + user_id, (data)->
    console.log data
    $('.notifications .notification').addClass 'read'

  jug.subscribe 'incoming-notification-user-' + user_id, (data)->
    make_notification data

  make_notification = (obj)->
    $el        = $notification_el.clone()
    time_text  = $el.find('.time').text()
    remove_url = $el.find('.remove').attr 'href'

    $el.removeClass('read')
    $el.find('.content').html obj.content
    $el.find('.time').html time_text + obj.created_at
    $el.find('.remove').attr 'href', remove_url + obj.id

    $('.notifications').prepend($el)
    $el.fadeIn()
