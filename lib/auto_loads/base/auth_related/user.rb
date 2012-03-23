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
  # --- 投票
  include Vote::UserMethods
  # --- 问答
  include Question::UserMethods
  include Answer::UserMethods
  # --- 短消息
  include ShortMessage::UserMethods
  include ShortMessageReading::UserMethods
end
