class DropCourseImagesAndCourseVideos < ActiveRecord::Migration
  def change
    drop_table :course_images
    drop_table :course_videos
  end
end
