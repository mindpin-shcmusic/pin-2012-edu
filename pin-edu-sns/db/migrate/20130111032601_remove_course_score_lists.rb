class RemoveCourseScoreLists < ActiveRecord::Migration
  def change
    drop_table :course_score_lists
  end
end
