class User < BuildDatabaseAbstract
  include UserMethods
  # admin 模块
  include Student::UserMethods
  include Teacher::UserMethods
  # --- 作业
  include Homework::UserMethods
  include HomeworkAssign::UserMethods
  include HomeworkStudentUploadRequirement::UserMethods
  include HomeworkStudentUpload::UserMethods
  # --- 媒体文件
  include MediaFile::UserMethods
  # --- 通知
  include Notification::UserMethods
end
