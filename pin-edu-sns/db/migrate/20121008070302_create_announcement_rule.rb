class CreateAnnouncementRule < ActiveRecord::Migration
  def change
    create_table :announcement_rules do |t|
      t.integer :creator_id
      t.integer :announcement_id
      t.text    :expression
      t.timestamps
    end
  end
end
