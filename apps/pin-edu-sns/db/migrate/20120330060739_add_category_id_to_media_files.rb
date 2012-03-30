class AddCategoryIdToMediaFiles < ActiveRecord::Migration
  def change
    add_column(:media_files, :category_id, :integer)
  end
end
