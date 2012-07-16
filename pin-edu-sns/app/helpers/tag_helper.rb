module TagHelper
  
  # 根据传入的tags数组，转成用于显示在list中的html代码
  def show_tags_in_list(tags)
    if tags.blank?
      return content_tag(
        :div,
        content_tag(:span, '没有标签', :class => 'name'),
        :class => 'no-tag'
      )
    end

    raw tags.map{|tag|
      content_tag(
        :div,
        content_tag(:span, h(tag.name), :class => 'name'),
        :class => 'tag'
      )
    }
  end
  
end