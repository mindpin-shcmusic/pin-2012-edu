# -*- coding: no-conversion -*-
module LayoutHelper
  def page_buttons
    content_tag :div, :class => :buttons do
      yield LayoutWidget
    end
  end

  def list_pagination(collection)
    str = content_tag(:span, :class => 'desc') {current_displaying_items_str_for(collection)}
    pagination = will_paginate(collection, :class => 'pagination')
    content_tag(:div, :class => 'paginate-info') {str + pagination}
  end

private

  def current_displaying_items_str_for(collection)
    offset = (params[:page] ? params[:page].to_i : 1) * Paginated::PERPAGE
    start  = collection.blank? ? 0 : offset - Paginated::PERPAGE + 1
    total  = collection.count
    stop   = offset > total ? total : offset
    "当前显示第#{start}-#{stop}项(共#{total}项)"
    [_make_span('当前显示第'),
     _make_span(start, 'count'),
     _make_span('-第'),
     _make_span(stop, 'count'),
     _make_span('条结果（共'),
     _make_span(total, 'count'),
     _make_span('条结果）')].reduce(&:+)
  end

  def _make_span(content, css_class=nil)
    content_tag :span, content, :class => [css_class]
  end

  module LayoutWidget
    extend ActionView::Helpers::UrlHelper
    extend ActionView::Helpers::TagHelper

    def self.button(text, path, options={})
      options.assert_valid_keys :class
      link_to text, path, :class => [:button, options[:class]]
    end
  end

end