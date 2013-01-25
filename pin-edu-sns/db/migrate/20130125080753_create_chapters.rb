class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string :title
      t.text   :desc
      t.integer :teaching_plan_id
      t.timestamps
    end
  end
end
