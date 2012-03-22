class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.integer :creator_id
      t.text    :content
      t.integer  :date   # 例如 # 20120318
      t.boolean  :completed, :default => false
      t.timestamps
    end
  end
end
