pie.load ->
  class Notifier
    collection = []
    id_maker  = 0

    constructor: (selector)->
      id_maker++
      @$el = $ selector
      @id  = id_maker
      collection.push this
      @$el.data 'id', @id

    update_text: ->
      @$content.text "#{this.get_data()}"

    subscribe: (juggernaut, channel)->
      new Subscriber(juggernaut, channel, this)

    fade_in: ->
      @$el.fadeIn()

    fade_out: ->
      @$el.fadeOut()

    get_data: ->
      @$el.data 'data'

    set_data: (data)->
      @$el.data 'data', data

    @find: (id)->
      collection.filter((element)->
        element.id == id)[0]

    @all: ->
      collection

  class Counter extends Notifier
    constructor: (selector, dependent)->
      super selector
      @$content = @$el.find '.content'
      if dependent
        @dependent = dependent
        @dependent.notifier = this

    get_data: ->
      @$el.data 'data'

    set_data: (data)->
      @$el.data 'data', data

    @any_count: ->
      @all().some (element)->
        element.get_data() > 0

    hide_container: ->
      @$el.parent().fadeOut() unless @constructor.any_count()

    update_text: ->
      @$content.text "#{this.get_data()}"

    display: ->
      count = @dependent.get_data()
      @set_data count

      if count > 0
        @update_text()
        @fade_in()
      else
        @fade_out()

  class CommentMessageNotifier extends Counter
    update_text: ->
      @$content.text "#{this.get_data()}条未读评论"

  class NotificationNotifier extends Counter
    update_text: ->
      @$content.text "#{this.get_data()}条未读通知"

  class ShortMessageNotifier extends Counter
    update_text: ->
      @$content.text "#{this.get_data()}条未读站内信"

  class MediaShareNotifier extends Counter
    update_text: ->
      @$content.text "#{this.get_data()}个新文件分享"

  class ShareRateNotifier extends Notifier
    update_text: ->
      data = this.get_data()
      @$el.text "分享率#{data.rate}, 分享率排名#{data.rank}"

    subscribe: (juggernaut, channel)->
      new ShareRateSubscriber(juggernaut, channel, this)

  class Subscriber
    constructor: (@juggernaut, @channel, @notifier)->
      subscribe @juggernaut, @channel, @notifier

    subscribe = (juggernaut, channel, notifier)->
      juggernaut.subscribe channel, (data)->
        notifier.set_data data.count

        if notifier.notifier
          notifier.notifier.display()

        if notifier.get_data() > 0
          notifier.$el.parent().fadeIn()
          notifier.update_text()
          notifier.fade_in()
        else
          notifier.fade_out()
          console.log '>>>>', notifier.get_data()
          notifier.hide_container() #需要确保在所有notifier以及counter的count都set后再运行...

  class ShareRateSubscriber extends Subscriber
    constructor: (@juggernaut, @channel, @notifier)->
      subscribe @juggernaut, @channel, @notifier

    subscribe = (juggernaut, channel, notifier)->
      console.log(channel)
      juggernaut.subscribe channel, (data)->
        console.log(data)
        notifier.set_data data
        notifier.update_text()
        notifier.fade_in().delay(4000).fadeOut()


  names =
    Counter                : Counter
    Notifier               : Notifier
    NotificationNotifier   : NotificationNotifier
    ShareRateNotifier      : ShareRateNotifier
    CommentMessageNotifier : CommentMessageNotifier
    ShortMessageNotifier   : ShortMessageNotifier
    MediaShareNotifier     : MediaShareNotifier
    Subscriber             : Subscriber
    ShareRateSubscriber    : ShareRateSubscriber
    USER_ID                : window.USER_INFO.id

  jQuery.extend window, names