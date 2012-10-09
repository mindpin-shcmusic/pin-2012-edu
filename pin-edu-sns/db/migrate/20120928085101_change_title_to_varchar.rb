class ChangeTitleToVarchar < ActiveRecord::Migration
  def change
    change_column :course_surveys, :title, :string
  end
end
