class AddSavedSizeToFileEntities < ActiveRecord::Migration
  def change
    add_column :file_entities, :saved_size, :integer, :limit => 8
  end
end
