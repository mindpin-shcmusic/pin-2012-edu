class CreateConnectUsers < ActiveRecord::Migration
  def change
    create_table :connect_users do |t|
      t.integer  "user_id"
      t.string   "connect_type"
      t.string   "connect_id"
      t.string   "oauth_token"
      t.string   "oauth_token_secret"
      t.text     "account_detail"
      t.boolean  "oauth_invalid"
      t.boolean  "syn_from_connect"
      t.string   "last_syn_message_id"
      t.timestamps
    end
  end
end
