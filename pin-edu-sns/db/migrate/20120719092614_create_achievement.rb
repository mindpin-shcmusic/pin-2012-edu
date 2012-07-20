class CreateAchievement < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.integer  :user_id
      t.string   :share_rate
      t.timestamps
    end
  end
end
