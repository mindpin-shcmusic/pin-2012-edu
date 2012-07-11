$ ->
  class Notifier
    constructor: (selector)->
      @el      = $ selector
      @content = @el.find '.content'

    get_count: ->
      @el.data 'count'

    set_count: (count)->
      @el.data 'count', count

    update_text: ->
      @content.text "#{this.get_count()}条消息"

    fade_in: ->
      @el.fadeIn()

    fade_out: ->
      @el.fadeOut()

    subscribe: (juggernaut, channel)->
      new Subscriber(juggernaut, channel, this)

  class CommentMessageNotifier extends Notifier
    update_text: ->
      @content.text "#{this.get_count()}条未读评论"

  class NotificationNotifier extends Notifier
    update_text: ->
      @content.text "#{this.get_count()}条未读通知"

  class Subscriber
    constructor: (@juggernaut, @channel, @notifier)->
      subscribe @juggernaut, @channel, @notifier

    subscribe = (juggernaut, channel, notifier)->
      juggernaut.subscribe channel, (data)->
        notifier.set_count data.count

        console.log notifier.get_count()

        if notifier.get_count() > 0
          notifier.el.parent().show()
          notifier.update_text()
          notifier.fade_in()
        else
          notifier.fade_out()
          hide_notifier_container()

        display_unread_count()

  jug                      = new Juggernaut
  notification_notifier    = new NotificationNotifier('.notification-notifier')
  comment_message_notifier = new CommentMessageNotifier('.comment-message-notifier')
  user_id                  = $('meta[current-user-id]').attr 'current-user-id'
  $notification_el         = $ '.notification.empty'
  $unread_count            = $ '.notification-unread-count'

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

  any_notifier_count = ->
    notification_notifier.get_count() > 0 ||
    comment_message_notifier.get_count()      > 0

  hide_notifier_container = ->
    $('.notifier').fadeOut() unless any_notifier_count()

  display_unread_count = ->
    count = notification_notifier.get_count()

    if count > 0
      $unread_count.text count
      $unread_count.fadeIn()
    else
      $unread_count.fadeOut()
