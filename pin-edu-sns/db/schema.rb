# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120723033452) do

  create_table "achievements", :force => true do |t|
    t.integer  "user_id"
    t.float    "share_rate", :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["parent_id"], :name => "index_categories_on_parent_id"

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

  add_index "comments", ["creator_id"], :name => "index_comments_on_creator_id"
  add_index "comments", ["model_id", "model_type"], :name => "index_comments_on_model_id_and_model_type"
  add_index "comments", ["reply_comment_id"], :name => "index_comments_on_reply_comment_id"
  add_index "comments", ["reply_comment_user_id"], :name => "index_comments_on_reply_comment_user_id"

  create_table "connect_users", :force => true do |t|
    t.integer  "user_id"
    t.string   "connect_type"
    t.string   "connect_id"
    t.string   "oauth_token"
    t.string   "oauth_token_secret"
    t.text     "account_detail"
    t.boolean  "oauth_invalid"
    t.boolean  "syn_from_connect"
    t.string   "last_syn_message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_students", :force => true do |t|
    t.integer  "course_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  add_index "courses", ["teacher_id"], :name => "index_courses_on_teacher_id"

  create_table "file_entities", :force => true do |t|
    t.string   "attach_file_name"
    t.string   "attach_content_type"
    t.integer  "attach_file_size"
    t.datetime "attach_updated_at"
    t.string   "md5"
    t.boolean  "merged",              :default => false
    t.string   "video_encode_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "file_entities", ["md5"], :name => "index_file_entities_on_md5"

  create_table "homework_assigns", :force => true do |t|
    t.integer  "student_id"
    t.integer  "homework_id"
    t.text     "content"
    t.boolean  "is_submit",    :default => false
    t.datetime "submitted_at"
    t.boolean  "has_finished", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "homework_assigns", ["homework_id"], :name => "index_homework_assigns_on_homework_id"
  add_index "homework_assigns", ["student_id"], :name => "index_homework_assigns_on_student_id"

  create_table "homework_student_upload_requirements", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "homework_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "homework_student_upload_requirements", ["creator_id"], :name => "index_homework_student_upload_requirements_on_creator_id"
  add_index "homework_student_upload_requirements", ["homework_id"], :name => "index_homework_student_upload_requirements_on_homework_id"

  create_table "homework_student_uploads", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "attachement_id"
    t.string   "attachement_file_name"
    t.string   "attachement_content_type"
    t.integer  "attachement_file_size"
    t.datetime "attachement_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "homework_student_uploads", ["creator_id"], :name => "index_homework_student_uploads_on_creator_id"

  create_table "homework_teacher_attachements", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "homework_id"
    t.string   "attachement_file_name"
    t.string   "attachement_content_type"
    t.integer  "attachement_file_size"
    t.datetime "attachement_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "homework_teacher_attachements", ["creator_id"], :name => "index_homework_teacher_attachements_on_creator_id"
  add_index "homework_teacher_attachements", ["homework_id"], :name => "index_homework_teacher_attachements_on_homework_id"

  create_table "homeworks", :force => true do |t|
    t.integer  "creator_id"
    t.string   "title"
    t.text     "content"
    t.integer  "course_id"
    t.datetime "deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "homeworks", ["course_id"], :name => "index_homeworks_on_course_id"
  add_index "homeworks", ["creator_id"], :name => "index_homeworks_on_creator_id"

  create_table "media_files", :force => true do |t|
    t.string   "entry_file_name"
    t.string   "entry_content_type"
    t.integer  "entry_file_size",     :limit => 8
    t.datetime "entry_updated_at"
    t.string   "place"
    t.text     "desc"
    t.integer  "creator_id"
    t.integer  "category_id"
    t.string   "video_encode_status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "file_merged"
    t.string   "real_file_name"
    t.string   "md5"
    t.text     "description"
  end

  add_index "media_files", ["category_id"], :name => "index_media_files_on_category_id"
  add_index "media_files", ["creator_id"], :name => "index_media_files_on_creator_id"

  create_table "media_resources", :force => true do |t|
    t.integer  "file_entity_id"
    t.string   "name"
    t.boolean  "is_dir",         :default => false
    t.integer  "dir_id",         :default => 0
    t.integer  "creator_id"
    t.datetime "fileops_time"
    t.boolean  "is_removed",     :default => false
    t.integer  "files_count",    :default => 0
    t.boolean  "delta",          :default => true,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "media_resources", ["creator_id"], :name => "index_media_resources_on_creator_id"
  add_index "media_resources", ["dir_id"], :name => "index_media_resources_on_dir_id"
  add_index "media_resources", ["file_entity_id"], :name => "index_media_resources_on_file_entity_id"
  add_index "media_resources", ["fileops_time"], :name => "index_media_resources_on_fileops_time"
  add_index "media_resources", ["name"], :name => "index_media_resources_on_name"

  create_table "media_share_rules", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "media_resource_id"
    t.text     "expression"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_shares", :force => true do |t|
    t.integer  "media_resource_id"
    t.integer  "creator_id"
    t.integer  "receiver_id"
    t.boolean  "delta",             :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.text     "content"
    t.integer  "receiver_id"
    t.boolean  "read",        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "online_records", :force => true do |t|
    t.integer  "user_id"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_records", ["key"], :name => "index_online_records_on_key"
  add_index "online_records", ["user_id"], :name => "index_online_records_on_user_id"

  create_table "public_resources", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "media_resource_id"
    t.integer  "file_entity_id"
    t.string   "kind"
    t.string   "name"
    t.boolean  "delta",             :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "short_messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.text     "content"
    t.boolean  "receiver_read", :default => false
    t.boolean  "sender_hide",   :default => false
    t.boolean  "receiver_hide", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slice_temp_files", :force => true do |t|
    t.integer  "creator_id"
    t.string   "entry_file_name"
    t.string   "entry_content_type"
    t.integer  "entry_file_size",    :limit => 8
    t.datetime "entry_updated_at"
    t.integer  "saved_size",         :limit => 8
    t.boolean  "merged"
    t.string   "real_file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", :force => true do |t|
    t.string   "real_name",  :default => "", :null => false
    t.string   "sid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "students", ["user_id"], :name => "index_students_on_user_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "creator_id"
    t.integer  "model_id"
    t.string   "model_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["creator_id"], :name => "index_taggings_on_creator_id"
  add_index "taggings", ["model_id", "model_type"], :name => "index_taggings_on_model_id_and_model_type"
  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"

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

  add_index "teachers", ["user_id"], :name => "index_teachers_on_user_id"

  create_table "team_students", :force => true do |t|
    t.integer  "team_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_students", ["student_id"], :name => "index_team_students_on_student_id"
  add_index "team_students", ["team_id"], :name => "index_team_students_on_team_id"

  create_table "teams", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.string   "cid"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["teacher_id"], :name => "index_teams_on_teacher_id"

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

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["name"], :name => "index_users_on_name"

end
