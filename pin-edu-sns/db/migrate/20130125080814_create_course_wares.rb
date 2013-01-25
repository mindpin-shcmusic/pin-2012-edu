class CreateCourseWares < ActiveRecord::Migration
  def change
    create_table :course_wares do |t|
      t.string :title
      t.text :desc
      t.integer :chapter_id
      t.string :kind # PPT VIDEO ...
      t.integer :media_resource_id
      t.timestamps
    end
  end
end
