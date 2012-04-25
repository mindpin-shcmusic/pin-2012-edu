class DropQuestionsRelatedTables < ActiveRecord::Migration
  def up
    drop_table :answer_votes
    drop_table :answers
    drop_table :questions
  end

  def down
  end
end
