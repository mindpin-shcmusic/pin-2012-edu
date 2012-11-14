class AddExtraToTeachers < ActiveRecord::Migration
  def change
    # 部门
    add_column :teachers, :department, :string

    # 电话
    add_column :teachers, :tel, :string

    # 性别
    add_column :teachers, :gender, :string

    # 民族
    add_column :teachers, :nation, :string

    # 政治面貌
    add_column :teachers, :politics_status, :string

    # 身份证号
    add_column :teachers, :id_card_number, :string

    # 备注
    add_column :teachers, :other_info, :text
  end
end
