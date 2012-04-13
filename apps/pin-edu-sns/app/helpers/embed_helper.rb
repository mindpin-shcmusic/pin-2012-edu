module EmbedHelper
  def video_tag(src)
    %`
    <embed 
      height="356" 
      allowscriptaccess="never" 
      style="visibility: visible;" 
      pluginspage="http://get.adobe.com/cn/flashplayer/" 
      flashvars="" 
      width="440" 
      allowfullscreen="true" 
      quality="hight" 
      src="#{src}"
      type="application/x-shockwave-flash" 
      wmode="opaque"
      data-pinit="registered">
      </embed>
    `

  end
end