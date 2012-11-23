# -*- coding: utf-8 -*-
class CommentsController < ApplicationController
  before_filter :login_required
  
  def create
    klass = params[:model_type].constantize
    model = klass.find params[:model_id]

    comment = model.comments.new
    comment.content = params[:content]
    comment.reply_comment_id = params[:reply_comment_id]
    comment.creator = current_user

    if comment.save
      return render :partial =>'aj/comments', 
                    :locals => {
                      :model => model,
                      :comments => [comment]
                    }
    end

    render :status => 403,
           :text => '评论创建失败'

  rescue Exception => ex
    render :status => 403,
           :text => '评论创建失败'
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.destroy
      render :text => '删除成功'
    end
  end

  def show_model_comments
    klass = params[:model_type].constantize
    model = klass.find params[:model_id]

    return render :partial =>'aj/comments', 
                  :locals => {
                    :model => model
                  }
  end

  def received
    @comments = current_user.received_comments.paginate :page => params[:page],
                                                        :per_page => 20
    do_clear_comment_tip_message!
  rescue Redis::CannotConnectError
    @error_message = '无法获取收到的评论。'
  end

protected

  def do_clear_comment_tip_message!
    if logged_in?
      current_user.comment_tip_message.clear
      current_user.comment_tip_message.send_count_to_juggernaut
    end
  end

end
