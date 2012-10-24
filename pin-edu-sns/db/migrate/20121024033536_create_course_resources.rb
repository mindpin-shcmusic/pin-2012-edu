class CreateCourseResources < ActiveRecord::Migration
  def change
    create_table :course_resources do |t|
      t.integer :course_id
      t.integer :file_entity_id
      t.integer :creator_id
      t.string :name
      t.string :kind
      t.timestamps
    end
  end
end
