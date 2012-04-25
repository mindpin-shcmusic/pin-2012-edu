class DropVoteRelatedTables < ActiveRecord::Migration
  def up
    drop_table :vote_items
    drop_table :vote_result_items
    drop_table :vote_results
    drop_table :votes
  end

  def down
  end
end
