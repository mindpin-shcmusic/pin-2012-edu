module EmbedHelper
  def video_tag(media_file)
    %~
      <embed 
        height='356' 
        allowscriptaccess='never' 
        style='visibility:visible;' 
        pluginspage='http://get.adobe.com/cn/flashplayer/' 
        flashvars='' 
        width='440' 
        allowfullscreen='true' 
        quality='hight' 
        src="#{media_file.swf_player_url}"
        type='application/x-shockwave-flash' 
        wmode='opaque'
        data-pinit='registered'
      >
      </embed>
    ~.html_safe

  end
end