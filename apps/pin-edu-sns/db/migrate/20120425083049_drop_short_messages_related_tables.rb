class DropShortMessagesRelatedTables < ActiveRecord::Migration
  def up
    drop_table :short_message_readings
    drop_table :short_messages
  end

  def down
  end
end
