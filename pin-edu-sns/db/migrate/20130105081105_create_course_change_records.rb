class CreateCourseChangeRecords < ActiveRecord::Migration
  def change
    create_table :course_change_records do |t|
      t.integer   :course_id
      t.integer   :teacher_user_id
      t.string    :location
      t.string    :time_expression
      t.string    :semester_value
      t.datetime  :start_date
      t.datetime  :end_date
      t.timestamps
    end
  end
end
