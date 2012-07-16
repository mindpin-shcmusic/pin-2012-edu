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
  end

end