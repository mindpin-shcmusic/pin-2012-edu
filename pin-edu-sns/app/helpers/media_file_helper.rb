module MediaFileHelper

  def media_file_cover_src(media_file)

    case media_file.content_kind
    when :image
      return media_file.entry.url(:small)
    when :audio
      return '/assets/covers/audio.small.png'
    when :video
      return '/assets/covers/video.small.png'
    when :document
      return '/assets/covers/document.small.png'
    else
      return '/assets/covers/normal.small.png'
    end

  end

end
