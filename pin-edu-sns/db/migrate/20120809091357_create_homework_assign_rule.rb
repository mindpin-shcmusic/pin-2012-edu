class CreateHomeworkAssignRule < ActiveRecord::Migration
  def change
    create_table :homework_assign_rules do |t|
      t.integer :creator_id
      t.integer :homework_id
      t.text    :expression
      t.timestamps
    end
  end
end
