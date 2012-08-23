# -*- coding: utf-8 -*-
module HomeworkHelper
  # 为了让comments/received页面给student_upload评论也返回评论
  def homework_student_upload_path(upload)
    "/homeworks/#{upload.homework.id}/students/#{upload.creator.id}"
  end
end
