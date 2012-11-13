class AddOtherInfoToStudents < ActiveRecord::Migration
  def change
    # 备注
    add_column :students, :other_info, :text
  end
end
