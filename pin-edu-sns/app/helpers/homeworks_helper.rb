# -*- coding: utf-8 -*-
module HomeworksHelper

  def timeline_button
    timeline_open? ? button_template('切换到列表视图', nil) : button_template('切换到时间线视图', true)
  end

  def button_template(text, status)
    link_to text, homeworks_path(:timeline => status), :class => 'homeworks-timeline-button'
  end

  def timeline_open?
    params[:timeline]
  end

end
