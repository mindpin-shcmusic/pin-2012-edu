class CreateTeachingPlans < ActiveRecord::Migration
  def change
    drop_table :teaching_plans

    create_table :teaching_plans do |t|
      t.string   :title
      t.text     :desc
      t.integer  :course_id
      t.integer  :teacher_user_id
      t.string   :semester_value
      t.timestamps
    end
  end
end
