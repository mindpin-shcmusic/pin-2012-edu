class RenameCoursesImageToCourseImage < ActiveRecord::Migration
  def change
    rename_table :courses_images, :course_images
  end
end
