class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer  :creator_id
      t.integer  :question_id
      t.text     :content

      t.timestamps
    end
  end
end
