class ChangeColumnsOfCourseScoreRecords < ActiveRecord::Migration
  def change
    remove_column :course_score_records, :course_score_list_id
    change_column :course_score_records, :remark, :text

    add_column :course_score_records, :course_id, :integer
    add_column :course_score_records, :creator_id, :integer
  end
end
