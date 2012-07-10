class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.text :content
      t.integer :receiver_id
      t.boolean :read, :default => false

      t.timestamps
    end
  end
end
