class RenameMistakenTestPaperJoinTableColumn < ActiveRecord::Migration
  def up
    change_table :test_paper_test_questions do |t|
      if t.column_exists?(:teaching_plan_id)
        rename_column :test_paper_test_questions, :teaching_plan_id, :test_question_id
      end
    end
  end

  def down
  end
end
