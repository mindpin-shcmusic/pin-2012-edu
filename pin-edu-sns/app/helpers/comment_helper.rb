module CommentHelper

  def do_clear_comment_tip_message!
    if logged_in?
      current_user.comment_tip_message.clear
      current_user.comment_tip_message.send_count_to_juggernaut
    end
  end

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
