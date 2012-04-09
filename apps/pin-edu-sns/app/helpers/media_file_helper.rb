module MediaFileHelper
  def media_files_list(c)
    category = c if c
    if params[:uncategorized]
      uncategorized_media_files
    else
      own_and_descendants_media_files(c)
    end
  end

  def show_media_files
    return media_files_list(cur_c) if cur_c
    MediaFile.all unless params[:uncategorized] || cur_c
  end
  alias :mfs :show_media_files

  def current_level1_category
    cur_c.root if cur_c
  end
  alias :c1 :current_level1_category

  def current_level2_category
    if cur_lv == 1
      cur_c
    elsif c3
      c3.parent
    end
  end
  alias :c2 :current_level2_category

  def current_level3_category
    cur_c if cur_lv == 2
  end
  alias :c3 :current_level3_category

  def current_category
    Category.find(params[:category_id]) if params[:category_id]
  end
  alias :cur_c :current_category
  
  def current_level
    cur_c.level if cur_c
  end
  alias :cur_lv :current_level

  def render_category_li category, *classes, &b
    if block_given?
      dropdown = capture(&b)
    else
      dropdown = ""
    end
    url_media_files = params[:index_alt] ?
    media_files_url(:category_id => category.id, :index_alt => true) :
    media_files_url(:category_id => category.id)
    content_tag :li, :class => [:category, classes] do
      link_to(category.name, url_media_files)+
      dropdown
    end
  end
  alias :rcl :render_category_li

private

  def own_and_descendants_media_files(category)
    category.media_files+
    (category.descendants.map do |c|
      c.media_files
    end.reduce(:+) || []) if category
  end

  def uncategorized_media_files
    MediaFile.where(:creator_id => nil)
  end
end
