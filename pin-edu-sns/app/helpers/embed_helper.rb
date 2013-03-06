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

  def swf_tag(swf_url, width=640, height=480)
    content_tag :embed, '', {
      :width            => width,
      :height           => height,
      :allowfullscreen  => 'true',
      :allowscripaccess => 'always',
      :src              => swf_url,

      :pluginspage      => 'http://get.adobe.com/cn/flashplayer/',
      :quality          => 'high',
      :type             => 'application/x-shockwave-flash',
      :wmode            => 'opaque'
    }
  end
end
