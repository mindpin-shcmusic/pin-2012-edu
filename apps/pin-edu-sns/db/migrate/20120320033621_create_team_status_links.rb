class CreateTeamStatusLinks < ActiveRecord::Migration
  def change
    create_table :team_status_links do |t|
      t.integer :team_id
      t.integer :status_id
      t.timestamps
    end
  end
end
