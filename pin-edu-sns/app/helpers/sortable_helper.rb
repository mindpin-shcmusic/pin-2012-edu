module SortableHelper
  def sortable(column, header)
    dir       = is_current_sort?(column) && params[:dir] == 'asc' ? 'desc' : 'asc'
    css_class = is_current_sort?(column) ? "current-sort #{params[:dir] && 'sort-' + params[:dir]}" : nil
    link_to header, {:sort => column, :dir => dir}, {:class => css_class}
  end

private

  def is_current_sort?(column)
    column == params[:sort]
  end

end
