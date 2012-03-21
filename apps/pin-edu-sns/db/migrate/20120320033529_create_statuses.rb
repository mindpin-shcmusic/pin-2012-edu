class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.text :content
      t.integer :creator_id
      t.integer :repost_id
      t.timestamps
    end
  end
end
