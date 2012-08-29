class AddTimestampToCourse < ActiveRecord::Migration
  def change
    add_column :course_videos, :created_at, :datetime
    add_column :course_videos, :updated_at, :datetime
  end
end
