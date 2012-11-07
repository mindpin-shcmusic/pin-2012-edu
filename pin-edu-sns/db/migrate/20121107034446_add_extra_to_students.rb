class AddExtraToStudents < ActiveRecord::Migration
  def change
    # 学院
    add_column :students, :faculty, :string

    # 专业
    add_column :students, :major, :string

    # 性别
    add_column :students, :gender, :string

    # 年级
    add_column :students, :grade, :string

    # 学生类别
    add_column :students, :kind, :string

    # 入学日期
    add_column :students, :entry_date, :datetime

    # 毕业年份
    add_column :students, :graduation_year, :integer

    # 辅修专业
    add_column :students, :option_course, :string

    # 考生号
    add_column :students, :exam_id, :string

    # 毕业标注 (true 已经毕业 false 未毕业)
    add_column :students, :has_graduated, :boolean

    # 是否已离校 (true 已经离校 false 未离校)
    add_column :students, :has_left, :boolean


    # 民族
    add_column :students, :nation, :string


    # 政治面貌
    add_column :students, :politics_status, :string


    # 备注
    add_column :students, :description, :text

    # 原籍
    add_column :students, :native_home, :string

    # 家庭详细地址
    add_column :students, :home_address, :string

    # 生源地
    add_column :students, :source_place, :string

    # 出生日期
    add_column :students, :birthday, :datetime

    # 联系电话
    add_column :students, :tel, :string

    # 邮政编码
    add_column :students, :zip_code, :string

    # 身份证号
    add_column :students, :id_card_number, :string


    # 文化程度
    add_column :students, :edu_level, :string

    # 异动信息
    add_column :students, :exception_info, :string

    # 异动备注
    add_column :students, :exception_desc, :text


    # 毕业学校
    add_column :students, :graduated_school, :string

    # 毕业时间
    add_column :students, :graduated_date, :datetime


    # 联系人
    add_column :students, :contact_person, :string

    # 联系电话
    add_column :students, :contact_tel, :string

  end
end
