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

  def chapter1_ppt(options)
    width = options[:width]
    height = options[:height]
    demo_ppt_tag("http://agile.mindpin.com/chapter1_ppt.swf",width,height)
  end

  def chapter2_ppt(options)
    width = options[:width]
    height = options[:height]
    demo_ppt_tag("http://agile.mindpin.com/chapter2_ppt.swf",width,height)
  end

  def demo_ppt_tag(src,width,height)
    content_tag :embed, '', {
      :width            => width || 640,
      :height           => height || 400,
      :allowfullscreen  => 'true',
      :allowscripaccess => 'always',
      :src              => src,
      :flashvars        => "",

      :pluginspage      => 'http://get.adobe.com/cn/flashplayer/',
      :quality          => 'high',
      :type             => 'application/x-shockwave-flash',
      :wmode            => 'opaque'
    }
  end

end