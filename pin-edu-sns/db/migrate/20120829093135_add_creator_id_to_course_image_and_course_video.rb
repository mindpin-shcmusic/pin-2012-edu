class AddCreatorIdToCourseImageAndCourseVideo < ActiveRecord::Migration
  def change
    add_column :course_videos, :creator_id, :integer
    add_column :course_images, :creator_id, :integer
  end
end
