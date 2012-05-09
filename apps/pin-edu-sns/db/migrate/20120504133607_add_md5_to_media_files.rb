class AddMd5ToMediaFiles < ActiveRecord::Migration
  def change
    add_column :media_files, :md5, :string
  end
end
