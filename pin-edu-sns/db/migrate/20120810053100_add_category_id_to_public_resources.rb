class AddCategoryIdToPublicResources < ActiveRecord::Migration
  def change
    add_column :public_resources, :category_id, :integer
  end
end
