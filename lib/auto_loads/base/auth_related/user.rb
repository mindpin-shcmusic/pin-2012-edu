class User < BuildDatabaseAbstract
  include UserMethods
  # admin 模块
  include Student::UserMethods
  include Teacher::UserMethods
  # --- 教学活动
  include ActivityAssign::UserMethods
  include Activity::UserMethods
  # --- 待办事项
  include Todo::UserMethods
  # --- 作业
  include Homework::UserMethods
  include HomeworkAssign::UserMethods
  include HomeworkStudentUploadRequirement::UserMethods
  include HomeworkStudentUpload::UserMethods
  # --- 问答
  include Question::UserMethods
  include Answer::UserMethods
  # --- 短消息
  include ShortMessage::UserMethods
  include ShortMessageReading::UserMethods
  # --- 媒体文件
  include MediaFile::UserMethods
end
