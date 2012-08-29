class AddNameToCourseImageAndCourseVideo < ActiveRecord::Migration
  def change
    add_column :course_images, :name, :string
    add_column :course_videos, :name, :string
  end
end
