# -*- coding: utf-8 -*-
module LayoutHelper
  def page_buttons
    content_tag :div, :class => :buttons do
      yield LayoutWidget.new(self)
    end
  end

  def page_list_head(options={})
    options.assert_valid_keys :cols
    content_tag :div, :class => :cells do
      yield LayoutWidget.new(self, options[:cols])
    end
  end

  def page_list_body(options={})
    options.assert_valid_keys :cols
    content_tag :div, :class => :cells do
      yield BodyWidget.new(self, options[:cols])
    end
  end

  def list_pagination(collection)
    str = content_tag(:span, :class => 'desc') {current_displaying_items_str_for(collection)}
    pagination = will_paginate(collection, :class => 'pagination')
    content_tag(:div, :class => 'paginate-info') {str + pagination}
  end

  def sortable(column, header)
    is_current = is_current_sort?(column)
    param_dir = params[:dir]

    dir       = is_current && param_dir == 'asc' ? 'desc' : 'asc'
    css_class = is_current ? "sortable current #{param_dir}" : 'sortable'
    link_to header, {:sort => column, :dir => dir}, {:class => css_class}
  end

  def _make_span(content, css_class=nil)
    content_tag :span, content, :class => [css_class]
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
    column.to_s == params[:sort].to_s
  end

  class LayoutWidget < ActionView::Base
    def initialize(context, cols_hash=nil)
      @context = context
      @cols_hash = cols_hash
    end

    def button(text, path, options={})
      options.assert_valid_keys :class, :'data-model'
      link_to text, path, :class => [:button, options[:class]], :'data-model' => options[:'data-model']
    end

    def cell(attr_name, text, options={})
      options.assert_valid_keys :sortable
      col = @cols_hash[attr_name] ? "col_#{@cols_hash[attr_name]}" : 'col_1'
      content_tag :div, :class => [:cell, col, attr_name.to_s.dasherize] do
        options[:sortable] ? @context.sortable(attr_name, text) : @context._make_span(text)
      end
    end

    def checkbox(options={})
      col = options[:col] ? "col_#{options[:col]}" : 'col_1'
      content_tag :div, :class => [:cell, col, :ckeckbox] do
        @context.jcheckbox :checkbox, :check, false, ''
      end
    end

    def batch_destroy(model)
      self.button '删除', 'javascript:;', :class => 'batch-destroy', :'data-model' => model.to_s
    end

  end

  class BodyWidget < ActionView::Base
    def initialize(context, cols_hash)
      @context   = context
      @cols_hash = cols_hash
    end

    def cell(*args, &block)
      attr_name = args.first

      if block_given?
        options = args.second || {}
        content = @context.capture(&block)
      else
        text = args.second
        content = @context._make_span(text)
        options = args.third || {}
      end

      col = @cols_hash[attr_name] ? "col_#{@cols_hash[attr_name]}" : 'col_1'

      content_tag :div, content, :class => [:cell, col, attr_name.to_s.dasherize]
    end

    def checkbox(model, options={})
      col = options[:col] ? "col_#{options[:col]}" : 'col_1'
      content_tag :div, :class => [:cell, col, :ckeckbox], :'data-model-id' => model.id do
        @context.jcheckbox :checkbox, :check, false, ''
      end
    end

  end
end
