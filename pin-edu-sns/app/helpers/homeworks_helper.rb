# -*- coding: utf-8 -*-
module HomeworksHelper

  def timeline_button
    timeline_open? ? button_template('收起作业时间线', nil) : button_template('展开作业时间线', true)
  end

private

  def button_template(text, status)
    link_to text, homeworks_path(:timeline => status), :class => 'homeworks-timeline-button'
  end

  def timeline_open?
    params[:timeline]
  end

end
