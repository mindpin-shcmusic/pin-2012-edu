pie.load ->
  if Juggernaut?
    jug = new Juggernaut
    media_share_notifier = new MediaShareNotifier('.media-share-notifier')
    console.log "user-share-tip-message-count-user-#{USER_ID}"
    media_share_notifier.subscribe jug, "user-share-tip-message-count-user-#{USER_ID}"