# -*- coding: utf-8 -*-
module LayoutHelper
  def page_buttons
    content_tag :div, :class => :buttons do
      yield LayoutWidget.produce(self)
    end
  end

  def page_list_head
    content_tag :div, :class => :cells do
      yield LayoutWidget.produce(self)
    end
  end

  def list_pagination(collection)
    str = content_tag(:span, :class => 'desc') {current_displaying_items_str_for(collection)}
    pagination = will_paginate(collection, :class => 'pagination')
    content_tag(:div, :class => 'paginate-info') {str + pagination}
  end

  def sortable(column, header)
    dir       = is_current_sort?(column) && params[:dir] == 'asc' ? 'desc' : 'asc'
    css_class = is_current_sort?(column) ? "current-sort #{params[:dir] && 'sort-' + params[:dir]}" : nil
    link_to header, {:sort => column, :dir => dir}, {:class => css_class}
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

  def is_current_sort?(column)
    column == params[:sort]
  end

  def _make_span(content, css_class=nil)
    content_tag :span, content, :class => [css_class]
  end

  class LayoutWidget < ActionView::Base
    @@instance = nil

    def initialize(context)
      @context = context
    end

    def self.produce(context)
      return @@instance if @@instance
      @@instance = self.new(context)
    end

    def button(text, path, options={})
      options.assert_valid_keys :class
      link_to text, path, :class => [:button, options[:class]]
    end

    def cell(attr_name, text, options={})
      options.assert_valid_keys :col, :sortable
      col = options[:col] ? "col_#{options[:col]}" : 'col_1'
      content_tag :div, :class => [:cell, col, attr_name.to_s.dasherize] do
        options[:sortable] ? @context.sortable(attr_name, text) : text
      end
    end

    def checkbox(options={})
      col = options[:col] ? "col_#{options[:col]}" : 'col_1'
      content_tag :div, :class => [:cell, col, :ckeckbox] do
        @context.jcheckbox :checkbox, :check, false, ''
      end
    end

  end
end
