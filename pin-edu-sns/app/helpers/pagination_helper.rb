# -*- coding: utf-8 -*-
module PaginationHelper

  def table_pagination(collection)
    str = content_tag(:span, :class => 'pagination-str') {current_displaying_items_str_for(collection)}
    pagination = will_paginate(collection)
    content_tag(:div, :class => 'page-paginate') {str + pagination}
  end

  def current_displaying_items_str_for(collection)
    offset = (params[:page] ? params[:page].to_i : 1) * Paginated::PERPAGE
    start  = offset - Paginated::PERPAGE + 1
    total  = collection.count
    stop   = offset > total ? total : offset
    "当前显示第#{start}-第#{stop}项(共#{total}项)"
  end

end
