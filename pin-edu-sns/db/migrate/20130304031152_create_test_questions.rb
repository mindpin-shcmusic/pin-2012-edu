class CreateTestQuestions < ActiveRecord::Migration
  def change
    create_table :test_questions do |t|
      t.integer :creator_id
      t.string  :title
      t.integer :teaching_plan_id

      t.timestamps
    end
  end
end
