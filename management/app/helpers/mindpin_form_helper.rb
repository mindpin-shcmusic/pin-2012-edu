module MindpinFormHelper
  def flash_info
    re = ''

    [:success, :error, :notice].each do |kind|
      info = flash[kind]
      if !info.blank?
        re += content_tag(:div, info, :class=>'page-flash-info')
      end
    end

    return re.html_safe
  end
end