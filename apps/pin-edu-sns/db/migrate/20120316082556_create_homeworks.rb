class CreateHomeworks < ActiveRecord::Migration
  def change
    create_table :homeworks do |t|
      t.integer :creator_id
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
