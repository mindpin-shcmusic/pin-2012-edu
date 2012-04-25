class HomeworksMerged < ActiveRecord::Migration
  def change
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
    add_index "homework_assigns","student_id"
    add_index "homework_assigns","homework_id"

    create_table "homework_student_upload_requirements", :force => true do |t|
      t.integer  "creator_id"
      t.integer  "homework_id"
      t.string   "title"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "homework_student_upload_requirements","creator_id"
    add_index "homework_student_upload_requirements","homework_id"

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
    add_index "homework_student_uploads","creator_id"

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
    add_index "homework_teacher_attachements","creator_id"
    add_index "homework_teacher_attachements","homework_id"

    create_table "homeworks", :force => true do |t|
      t.integer  "creator_id"
      t.string   "title"
      t.text     "content"
      t.integer  "course_id"
      t.datetime "deadline"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "homeworks","creator_id"
    add_index "homeworks","course_id"
  end
end
