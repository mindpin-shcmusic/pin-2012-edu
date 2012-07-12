$ ->
  jug                    = new Juggernaut
  short_message_notifier = new ShortMessageNotifier('.short-message-notifier')
  unread_count           = new Counter('.short-message-unread-count',
                                       short_message_notifier)

  short_message_notifier.subscribe jug, "short-message-count-#{USER_ID}"