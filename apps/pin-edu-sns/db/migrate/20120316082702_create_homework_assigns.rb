# -*- encoding : utf-8 -*-
class CreateHomeworkAssigns < ActiveRecord::Migration
  def change
    create_table :homework_assigns do |t|
      t.integer :creator_id
      t.integer :homework_id
      t.text :content
      t.boolean :is_submit, :default => false

      t.timestamps
    end
  end
end
