class CreateCoursesImages < ActiveRecord::Migration
  def change
    create_table :courses_images do |t|
      t.integer :course_id
      t.integer :file_entity_id
      t.string :kind #attachment|cover
      t.timestamps
    end
  end
end
