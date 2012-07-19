pie.load ->
  jug                    = new Juggernaut
  short_message_notifier = new ShortMessageNotifier('.short-message-notifier')
  unread_count           = new Counter('.short-message-unread-count',
                                       short_message_notifier)
  $short_message_el      = $ '.short-message.empty'

  short_message_notifier.subscribe jug, "short-message-count-user-#{USER_ID}"

  make_short_message = (obj)->
    $el        = $short_message_el.clone()
    remove_url = $el.find('.remove').attr 'href'
    read_url   = $el.find('.read').attr 'href'
    reply_url  = $el.find('.reply').attr 'href'
    user_url   = $el.find('.sender').attr 'href'

    $el.removeClass('read empty')
    $el.find('.content').html obj.content
    $el.find('.remove').attr 'href', remove_url + obj.id

    $('.short-messages').prepend($el)
    $el.fadeIn()
