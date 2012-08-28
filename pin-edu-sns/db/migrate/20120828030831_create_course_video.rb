class CreateCourseVideo < ActiveRecord::Migration
  def change
    create_table :course_videos do |t|
      t.integer :course_id
      t.integer :file_entity_id
    end
  end
end
