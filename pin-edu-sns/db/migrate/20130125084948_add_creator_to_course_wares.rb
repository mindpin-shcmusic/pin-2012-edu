class AddCreatorToCourseWares < ActiveRecord::Migration
  def change
    add_column :course_wares, :creator_id, :integer
  end
end
