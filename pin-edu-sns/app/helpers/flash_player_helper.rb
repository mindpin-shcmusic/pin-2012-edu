module FlashPlayerHelper
  def flash_player(url, first_frame=nil, width=640, height=480)
    content_tag :div, nil,
                :class => 'flash-player',
                :style => "width:#{width}px;height:#{height}px;",
                :data  => {:video => "http://#{request.host}#{url.gsub(/\?.*/, '')}", :'first-frame' => first_frame}
  end
end
