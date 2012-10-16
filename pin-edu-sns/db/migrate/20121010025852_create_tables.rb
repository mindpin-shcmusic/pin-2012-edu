class CreateTables < ActiveRecord::Migration
  def change
    # 基础
    # --------
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
      t.integer  "roles_mask"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "users", "email"
    add_index "users", "name"

    create_table "comments", :force => true do |t|
      t.integer  "model_id"
      t.string   "model_type"
      t.integer  "creator_id"
      t.text     "content"
      t.integer  "reply_comment_id"
      t.integer  "reply_comment_user_id"
      t.integer  "receiver_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "comments", "creator_id"
    add_index "comments", ["model_id", "model_type"]
    add_index "comments", "reply_comment_id"
    add_index "comments", "reply_comment_user_id"

    create_table "online_records", :force => true do |t|
      t.integer  "user_id"
      t.string   "key"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "online_records", "key"
    add_index "online_records", "user_id"


    # 消息和通知
    # --------
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
    add_index "short_messages", "sender_id"
    add_index "short_messages", "receiver_id"
    add_index "short_messages", "sender_hide"
    add_index "short_messages", "receiver_hide"

    create_table "announcements", :force => true do |t|
      t.string   "title"
      t.text     "content"
      t.integer  "creator_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "announcements", "creator_id"

    create_table "announcement_users", :force => true do |t|
      t.integer  "announcement_id"
      t.integer  "user_id"
      t.boolean  "read",            :default => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "announcement_users", "user_id"

    create_table "announcement_rules", :force => true do |t|
      t.integer  "creator_id"
      t.integer  "announcement_id"
      t.text     "expression"
      t.datetime "created_at"
      t.datetime "updated_at"
    end


    # 资源
    # --------
    create_table "categories", :force => true do |t|
      t.string   "name"
      t.integer  "parent_id"
      t.integer  "lft"
      t.integer  "rgt"
      t.integer  "depth"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "is_removed", :default => false
    end
    add_index "categories", "parent_id"
    add_index "categories", "is_removed"

    create_table "file_entities", :force => true do |t|
      t.string   "attach_file_name"
      t.string   "attach_content_type"
      t.integer  "attach_file_size",    :limit => 8
      t.datetime "attach_updated_at"
      t.string   "md5"
      t.boolean  "merged",                           :default => false
      t.string   "video_encode_status"
      t.integer  "saved_size",          :limit => 8
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "file_entities", "md5"
    add_index "file_entities", "merged"

    create_table "file_entity_oss_object_parts", :force => true do |t|
      t.integer  "file_entity_id"
      t.integer  "saved_size",     :limit => 8
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "file_entity_oss_object_parts", "file_entity_id"

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
    add_index "media_resources", "file_entity_id"
    add_index "media_resources", "is_dir"
    add_index "media_resources", "dir_id"
    add_index "media_resources", "creator_id"
    add_index "media_resources", "is_removed"

    create_table "media_share_rules", :force => true do |t|
      t.integer  "creator_id"
      t.integer  "media_resource_id"
      t.text     "expression"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "media_share_rules", "creator_id"
    add_index "media_share_rules", "media_resource_id"

    create_table "media_shares", :force => true do |t|
      t.integer  "media_resource_id"
      t.integer  "creator_id"
      t.integer  "receiver_id"
      t.boolean  "delta",             :default => true, :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "media_shares", "media_resource_id"
    add_index "media_shares", "creator_id"
    add_index "media_shares", "receiver_id"

    create_table "public_resources", :force => true do |t|
      t.integer  "creator_id"
      t.integer  "media_resource_id"
      t.integer  "file_entity_id"
      t.string   "kind"
      t.string   "name"
      t.boolean  "delta",             :default => true, :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "category_id"
    end
    add_index "public_resources", "creator_id"
    add_index "public_resources", "media_resource_id"
    add_index "public_resources", "file_entity_id"
    add_index "public_resources", "kind"
    add_index "public_resources", "category_id"

    create_table "taggings", :force => true do |t|
      t.integer  "tag_id"
      t.integer  "taggable_id"
      t.string   "taggable_type"
      t.integer  "tagger_id"
      t.string   "tagger_type"
      t.string   "context",       :limit => 128
      t.datetime "created_at"
    end
    add_index "taggings", "tag_id"
    add_index "taggings", ["taggable_id", "taggable_type", "context"]

    create_table "tags", :force => true do |t|
      t.string "name"
    end


    # 用户角色
    # --------
    create_table "students", :force => true do |t|
      t.string   "real_name",  :default => "",    :null => false
      t.string   "sid"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "is_removed", :default => false
    end
    add_index "students", "user_id"
    add_index "students", "is_removed"

    create_table "teachers", :force => true do |t|
      t.string   "real_name",   :default => "",    :null => false
      t.string   "tid"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "is_removed",  :default => false
      t.text     "description"
    end
    add_index "teachers", "user_id"
    add_index "teachers", "is_removed"


    # 班级
    # --------
    create_table "team_students", :force => true do |t|
      t.integer  "team_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "student_user_id"
    end
    add_index "team_students", "team_id"
    add_index "team_students", "student_user_id"

    create_table "teams", :force => true do |t|
      t.string   "name",                   :default => "",    :null => false
      t.string   "cid"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "is_removed",             :default => false
    end
    add_index "teams", "is_removed"


    # 课程
    # --------
    create_table "course_images", :force => true do |t|
      t.integer  "course_id"
      t.integer  "file_entity_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "name"
      t.integer  "creator_id"
    end
    add_index "course_images", "course_id"
    add_index "course_images", "creator_id"

    create_table "course_teachers", :force => true do |t|
      t.integer  "course_id"
      t.integer  "teacher_user_id"
      t.string   "location"
      t.string   "time_expression"
      t.string   "semester_value"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "course_teachers", "course_id"
    add_index "course_teachers", "teacher_user_id"

    create_table "course_student_assigns", :force => true do |t|
      t.integer "course_id"
      t.integer "teacher_user_id"
      t.integer "student_user_id"
      t.string  "semester_value"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "course_student_assigns", "course_id"
    add_index "course_student_assigns", "teacher_user_id"
    add_index "course_student_assigns", "student_user_id"

    create_table "course_videos", :force => true do |t|
      t.integer  "course_id"
      t.integer  "file_entity_id"
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "creator_id"
    end
    add_index "course_videos", "course_id"
    add_index "course_videos", "file_entity_id"

    create_table "courses", :force => true do |t|
      t.string   "name",       :default => "",    :null => false
      t.string   "cid"
      t.text     "desc"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "is_removed", :default => false
      t.text     "syllabus"
      t.integer  "cover_id"
    end
    add_index "courses", "is_removed"

    create_table "teaching_plan_courses", :force => true do |t|
      t.integer  "teaching_plan_id"
      t.integer  "course_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "teaching_plan_courses", "teaching_plan_id"

    create_table "teaching_plans", :force => true do |t|
      t.string   "title"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "is_removed"
    end
    add_index "teaching_plans", "is_removed"

    create_table "teaching_plan_students", :force => true do |t|
      t.integer "teaching_plan_id"
      t.integer "student_user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "teaching_plan_students", "teaching_plan_id"
    add_index "teaching_plan_students", "student_user_id"

    # 作业
    # --------
    create_table "homework_assign_rules", :force => true do |t|
      t.integer  "creator_id"
      t.integer  "homework_id"
      t.text     "expression"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "homework_assign_rules", "creator_id"
    add_index "homework_assign_rules", "homework_id"

    create_table "homework_assigns", :force => true do |t|
      t.integer  "homework_id"
      t.text     "content"
      t.boolean  "is_submit",    :default => false
      t.datetime "submitted_at"
      t.boolean  "has_finished", :default => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "user_id"
    end
    add_index "homework_assigns", "homework_id"
    add_index "homework_assigns", "is_submit"
    add_index "homework_assigns", "has_finished"

    create_table "homework_requirements", :force => true do |t|
      t.integer  "creator_id"
      t.integer  "homework_id"
      t.string   "title"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "homework_requirements", "creator_id"
    add_index "homework_requirements", "homework_id"

    create_table "homework_student_uploads", :force => true do |t|
      t.integer  "creator_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "homework_id"
      t.integer  "file_entity_id"
      t.string   "name"
      t.integer  "requirement_id"
    end
    add_index "homework_student_uploads", "creator_id"
    add_index "homework_student_uploads", "file_entity_id"
    add_index "homework_student_uploads", "requirement_id"

    create_table "homework_teacher_attachments", :force => true do |t|
      t.integer  "creator_id"
      t.integer  "homework_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "file_entity_id"
      t.string   "name"
    end
    add_index "homework_teacher_attachments", "creator_id"
    add_index "homework_teacher_attachments", "homework_id"
    add_index "homework_teacher_attachments", "file_entity_id"

    create_table "homeworks", :force => true do |t|
      t.integer  "creator_id"
      t.string   "title"
      t.text     "content"
      t.integer  "course_id"
      t.datetime "deadline"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "homeworks", "course_id"
    add_index "homeworks", "creator_id"

    # 课堂调查
    # --------
    create_table "course_surveys", :force => true do |t|
      t.string   "title"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "course_survey_records", :force => true do |t|
      t.integer  "course_survey_id"
      t.integer  "student_user_id"
      t.boolean  "on_off_class"
      t.boolean  "checking_institution"
      t.boolean  "class_order"
      t.string   "prepare_situation"
      t.string   "teaching_level"
      t.string   "teacher_morality"
      t.string   "class_content"
      t.string   "knowledge_level"
      t.string   "teaching_schedule"
      t.string   "teaching_interact"
      t.string   "board_writing_quality"
      t.string   "has_courseware"
      t.string   "courseware_quality"
      t.string   "speak_level"
      t.string   "study_result"
      t.string   "teaching_result"
      t.string   "result_reason"
      t.text     "suggestion"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "course_survey_records", "course_survey_id"
    add_index "course_survey_records", "student_user_id"


    # 问答
    # --------
    create_table "questions", :force => true do |t|
      t.integer  "creator_id"
      t.integer  "teacher_user_id"
      t.string   "title"
      t.text     "content"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "is_removed",      :default => false
      t.boolean  "has_answered",    :default => false
    end
    add_index "questions", "creator_id"
    add_index "questions", "teacher_user_id"
    add_index "questions", "is_removed"
    add_index "questions", "has_answered"

    create_table "answers", :force => true do |t|
      t.integer  "creator_id"
      t.integer  "question_id"
      t.text     "content"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "answers", "creator_id"
    add_index "answers", "question_id"

  end
end
