module CategoryHelper
  def recursive_categories(category)
    if category.children.any?
      content_tag :div, :class => :child_categories do
        category.children.map do |c|
          content_tag :div, :class => [:category, :child_category] do
            content_tag(:div, c.name, :class => :t)+
            content_tag(:div, 0, :class => :c)+
            if !c.has_max_depth?
              link_to("增加子数据分类", new_category_path(:parent_id => c.id))
            end+
            recursive_categories(c)
          end
        end.reduce(:<<)
      end
    end
  end
end
