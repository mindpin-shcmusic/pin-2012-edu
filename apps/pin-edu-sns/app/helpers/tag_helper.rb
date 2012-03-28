module TagHelper
  
  # 根据传入的tags数组，转成用于显示在list中的html代码
  def show_tags_in_list(tags)
    return if tags.blank?
    

    raw tags.map{|tag|
      content_tag(
        :div,
        content_tag(:span, h(tag.name), :class => 'name'),
        :class => 'tag'
      )
    }
  end
  
end