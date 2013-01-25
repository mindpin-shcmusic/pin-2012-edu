class AddCreatorIdToChapters < ActiveRecord::Migration
  def change
    add_column :chapters, :creator_id, :integer
  end
end
