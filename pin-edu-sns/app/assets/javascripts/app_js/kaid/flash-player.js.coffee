TSC.playerConfiguration.setFlashPlayerSwf('/flash-player.swf')

TSC.playerConfiguration.setAutoHideControls(true)
TSC.playerConfiguration.setBackgroundColor("#000000")
TSC.playerConfiguration.setCaptionsEnabled(false)
TSC.playerConfiguration.setSidebarEnabled(false)

TSC.playerConfiguration.setAutoPlayMedia(false)
TSC.playerConfiguration.setIsSearchable(false)
TSC.playerConfiguration.setEndActionType("stop")
TSC.playerConfiguration.setEndActionParam("true")
TSC.playerConfiguration.setAllowRewind(-1)
TSC.playerConfiguration.setProcessUnicodeNames(true)
TSC.localizationStrings.setLanguage(TSC.languageCodes.ENGLISH)

set_video = ()->
  $player = jQuery('.flash-player')
  video = $player.data('video')
  first_frame = $player.data('first-frame')
  $player.append('<div id=tscVideoContent></div>')
  TSC.playerConfiguration.setMediaSrc(video)
  TSC.playerConfiguration.setPosterImageSrc(first_frame)
  TSC.mediaPlayer.init("#tscVideoContent")

set_video()
