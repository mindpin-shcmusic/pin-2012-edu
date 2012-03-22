class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.string :category
      t.text :data
      t.boolean :is_read, :default => false

      t.timestamps
    end
  end
end
