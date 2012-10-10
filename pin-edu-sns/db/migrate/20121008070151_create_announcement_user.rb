class CreateAnnouncementUser < ActiveRecord::Migration
  def change
    create_table :announcement_users do |t|
      t.integer :announcement_id
      t.integer :user_id
      t.boolean :read, :default => false
      t.timestamps
    end
  end
end
