class CreateAnnouncement < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string  :title
      t.text    :content
      t.integer :creator_id

      t.timestamps
    end
  end
end
