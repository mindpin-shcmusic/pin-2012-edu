try {
  TSC.playerConfiguration.setFlashPlayerSwf('/flash-player.swf');

  TSC.playerConfiguration.setAutoHideControls(true);
  TSC.playerConfiguration.setBackgroundColor("#000000");
  TSC.playerConfiguration.setCaptionsEnabled(false);
  TSC.playerConfiguration.setSidebarEnabled(false);

  TSC.playerConfiguration.setAutoPlayMedia(false);
  TSC.playerConfiguration.setIsSearchable(false);
  TSC.playerConfiguration.setEndActionType("stop");
  TSC.playerConfiguration.setEndActionParam("true");
  TSC.playerConfiguration.setAllowRewind(-1);
  TSC.playerConfiguration.setProcessUnicodeNames(true);
  TSC.localizationStrings.setLanguage(TSC.languageCodes.ENGLISH);

  var $player = jQuery('.flash-player');
  var video = $player.data('video');
  var first_frame = $player.data('first-frame');
  $player.append('<div id=tscVideoContent></div>');
  TSC.playerConfiguration.setMediaSrc(video);
  TSC.playerConfiguration.setPosterImageSrc(first_frame);
  TSC.mediaPlayer.init("#tscVideoContent");
} catch (error) {
  console.log(error);
}

