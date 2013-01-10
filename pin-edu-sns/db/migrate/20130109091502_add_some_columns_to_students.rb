class AddSomeColumnsToStudents < ActiveRecord::Migration
  def change
    add_column :students, :is_graduated, :boolean, :default => false
    add_column :students, :jiu_ye_xie_yi_file_entity_id, :integer
    add_column :students, :bi_ye_jian_ding_file_entity_id, :integer
  end
end
