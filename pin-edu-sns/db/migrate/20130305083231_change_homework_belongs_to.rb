class ChangeHomeworkBelongsTo < ActiveRecord::Migration
  def up
    remove_column :homeworks, :teaching_plan_id
    add_column    :homeworks, :chapter_id, :integer
  end

  def down
    remove_column :homeworks, :chapter_id
    add_column    :homeworks, :teaching_plan_id, :integer
  end
end
