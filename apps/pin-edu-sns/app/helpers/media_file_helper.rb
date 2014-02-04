module MediaFileHelper

  def media_file_cover_src(media_file)

    case media_file.content_kind
    when :image
      return media_file.file.url(:small)
    when :audio
      return pin_url_for('sns', '/assets/covers/audio.small.png')
    when :video
      return pin_url_for('sns', '/assets/covers/video.small.png')
    when :document
      return pin_url_for('sns', '/assets/covers/document.small.png')
    else
      return pin_url_for('sns', '/assets/covers/other.small.png')
    end

  end

end
