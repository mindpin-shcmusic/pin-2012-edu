class DropConnectUsersTables < ActiveRecord::Migration
  def up
    drop_table :connect_users
  end

  def down
  end
end
