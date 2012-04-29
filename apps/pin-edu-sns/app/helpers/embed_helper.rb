module EmbedHelper
  def video_tag(media_file)
    content_tag :embed, '', {
      :width            => 640,
      :height           => 400,
      :allowfullscreen  => 'true',
      :allowscripaccess => 'always',
      :src              => '/player.swf',
      :flashvars        => "file=#{media_file.flv_file_url}",

      :pluginspage      => 'http://get.adobe.com/cn/flashplayer/',
      :quality          => 'high',
      :type             => 'application/x-shockwave-flash',
      :wmode            => 'opaque'
    }

# <embed
#   flashvars="file=/data/bbb.mp4&autostart=true"
#   allowfullscreen="true"
#   allowscripaccess="always"
#   id="player1"
#   name="player1"
#   src="player.swf"
#   width="480"
#   height="270"
# />


  end
end