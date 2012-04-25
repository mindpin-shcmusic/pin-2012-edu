class AprilMerged < ActiveRecord::Migration
  def change
    create_table "categories", :force => true do |t|
      t.string   "name"
      t.integer  "parent_id"
      t.integer  "lft"
      t.integer  "rgt"
      t.integer  "depth"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "categories","parent_id"

    create_table "comments", :force => true do |t|
      t.integer  "model_id"
      t.string   "model_type"
      t.integer  "creator_id"
      t.text     "content"
      t.integer  "reply_comment_id"
      t.integer  "reply_comment_user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "comments",["model_id","model_type"]
    add_index "comments","creator_id"
    add_index "comments","reply_comment_id"
    add_index "comments","reply_comment_user_id"

    create_table "courses", :force => true do |t|
      t.string   "name",       :default => "", :null => false
      t.string   "cid"
      t.string   "department"
      t.string   "location"
      t.integer  "teacher_id"
      t.text     "desc"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "courses","teacher_id"

    create_table "media_files", :force => true do |t|
      t.string   "file_file_name"
      t.string   "file_content_type"
      t.integer  "file_file_size"
      t.datetime "file_updated_at"
      t.string   "uuid"
      t.string   "place"
      t.text     "desc"
      t.integer  "creator_id"
      t.integer  "category_id"
      t.string   "video_encode_status"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "media_files","uuid"
    add_index "media_files","creator_id"
    add_index "media_files","category_id"

    create_table "online_records", :force => true do |t|
      t.integer  "user_id"
      t.string   "key"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "online_records", ["key"], :name => "index_online_records_on_key"
    add_index "online_records", ["user_id"], :name => "index_online_records_on_user_id"

    create_table "students", :force => true do |t|
      t.string   "real_name",  :default => "", :null => false
      t.string   "sid"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "students","user_id"

    create_table "taggings", :force => true do |t|
      t.integer  "tag_id"
      t.integer  "creator_id"
      t.integer  "model_id"
      t.string   "model_type"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "taggings","tag_id"
    add_index "taggings","creator_id"
    add_index "taggings",["model_id","model_type"]

    create_table "tags", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "teachers", :force => true do |t|
      t.string   "real_name",  :default => "", :null => false
      t.string   "tid"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "teachers","user_id"

    create_table "team_students", :force => true do |t|
      t.integer  "team_id"
      t.integer  "student_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "team_students","team_id"
    add_index "team_students","student_id"

    create_table "teams", :force => true do |t|
      t.string   "name",       :default => "", :null => false
      t.string   "cid"
      t.integer  "teacher_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "teams","teacher_id"

    create_table "users", :force => true do |t|
      t.string   "name",                      :default => "", :null => false
      t.string   "hashed_password",           :default => "", :null => false
      t.string   "salt",                      :default => "", :null => false
      t.string   "email",                     :default => "", :null => false
      t.string   "sign"
      t.string   "activation_code"
      t.string   "logo_file_name"
      t.string   "logo_content_type"
      t.integer  "logo_file_size"
      t.datetime "logo_updated_at"
      t.datetime "activated_at"
      t.string   "reset_password_code"
      t.datetime "reset_password_code_until"
      t.datetime "last_login_time"
      t.boolean  "send_invite_email"
      t.integer  "reputation",                :default => 0,  :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "users","email"
    add_index "users","name"

  end
end
