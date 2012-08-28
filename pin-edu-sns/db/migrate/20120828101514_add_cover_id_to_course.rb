class AddCoverIdToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :cover_id, :integer
  end
end
