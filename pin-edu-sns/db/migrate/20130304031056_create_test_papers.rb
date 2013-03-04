class CreateTestPapers < ActiveRecord::Migration
  def change
    create_table :test_papers do |t|
      t.integer :teaching_plan_id
      t.integer :student_user_id
      t.timestamps
  end
end
