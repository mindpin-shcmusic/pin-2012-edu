module CommentHelper

  def comment_from_content(comment)
    model = comment.model
    if model.class == HomeworkStudentUpload
      return truncate_u model.name, 16
    end
    return truncate_u model.content, 16
  rescue
    return 'error'
  end

end
