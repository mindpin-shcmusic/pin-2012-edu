# -*- coding: no-conversion -*-
module LayoutHelper
  def page_buttons
    content_tag :div, :class => :buttons do
      yield LayoutWidget
    end
  end

  def list_pagination(collection)
    str = content_tag(:span, :class => 'pagination-str') {current_displaying_items_str_for(collection)}
    pagination = will_paginate(collection)
    content_tag(:div, :class => 'page-paginate') {str + pagination}
  end

private

  def current_displaying_items_str_for(collection)
    offset = (params[:page] ? params[:page].to_i : 1) * Paginated::PERPAGE
    start  = collection.blank? ? 0 : offset - Paginated::PERPAGE + 1
    total  = collection.count
    stop   = offset > total ? total : offset
    "当前显示第#{start}-#{stop}项(共#{total}项)"
  end

  module LayoutWidget
    extend ActionView::Helpers::UrlHelper
    extend ActionView::Helpers::TagHelper

    def self.button(text, path, options={})
      options.assert_valid_keys :class
      link_to text, path, :class => [:botton, options[:class]]
    end
  end

end
