class AddShcmrsSyncTables < ActiveRecord::Migration
  def change
    create_table "file_entities" do |t|
      t.string   "attach_file_name"
      t.string   "attach_content_type"
      t.integer  "attach_file_size"
      t.datetime "attach_updated_at"
      t.string   "md5"
      t.boolean  "merged",              :default => false
      t.string   "video_encode_status"
      t.timestamps
    end
    add_index "file_entities", "md5"

    create_table "media_resources" do |t|
      t.integer  "file_entity_id"
      t.string   "name"
      t.boolean  "is_dir",         :default => false
      t.integer  "dir_id",         :default => 0
      t.integer  "creator_id"
      t.datetime "fileops_time"
      t.boolean  "is_removed",     :default => false
      t.integer  "files_count",    :default => 0
      t.boolean  "delta",          :default => true,  :null => false
      t.timestamps
    end
    add_index "media_resources", "creator_id"
    add_index "media_resources", "dir_id"
    add_index "media_resources", "file_entity_id"
    add_index "media_resources", "fileops_time"
    add_index "media_resources", "name"


    create_table "media_shares" do |t|
      t.integer  "media_resource_id"
      t.integer  "creator_id"
      t.integer  "receiver_id"
      t.boolean  "delta",             :default => true, :null => false
      t.timestamps
    end


    create_table "public_resources" do |t|
      t.integer  "creator_id"
      t.integer  "media_resource_id"
      t.integer  "file_entity_id"
      t.string   "kind"
      t.string   "name"
      t.boolean  "delta",             :default => true, :null => false
      t.timestamps
    end

    create_table "slice_temp_files" do |t|
      t.integer  "creator_id"
      t.string   "entry_file_name"
      t.string   "entry_content_type"
      t.integer  "entry_file_size",    :limit => 8
      t.datetime "entry_updated_at"
      t.integer  "saved_size",         :limit => 8
      t.boolean  "merged"
      t.string   "real_file_name"
      t.timestamps
    end

  end
end
