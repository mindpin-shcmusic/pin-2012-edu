class RemoveKindFromCourseImage < ActiveRecord::Migration
  def change
    remove_column :course_images, :kind
  end
end
