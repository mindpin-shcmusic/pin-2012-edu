# -*- coding: utf-8 -*-
module CategoryHelper
  def categories_or_media_file_count(category)
    if category.leaf?
      "文件数 #{category.media_files.count}"
    else
      "子分类数 #{category.descendants.count}"
    end
  end
end
