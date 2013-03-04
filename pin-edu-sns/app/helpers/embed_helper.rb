module EmbedHelper
  def video_tag(file_entry)
    content_tag :embed, '', {
      :width            => 640,
      :height           => 400,
      :allowfullscreen  => 'true',
      :allowscripaccess => 'always',
      :src              => '/player.swf',
      :flashvars        => "provider=http&file=#{file_entry.attach_flv_url}",

      :pluginspage      => 'http://get.adobe.com/cn/flashplayer/',
      :quality          => 'high',
      :type             => 'application/x-shockwave-flash',
      :wmode            => 'opaque'
    }
  end
end
