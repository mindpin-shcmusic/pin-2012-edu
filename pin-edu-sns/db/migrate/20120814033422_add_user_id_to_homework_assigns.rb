class AddUserIdToHomeworkAssigns < ActiveRecord::Migration
  def change
    add_column    :homework_assigns, :user_id, :integer
    remove_column :homework_assigns, :student_id
  end
end
