class AddDescriptionToMediaFiles < ActiveRecord::Migration
  def change
    add_column :media_files, :description, :text
  end
end
