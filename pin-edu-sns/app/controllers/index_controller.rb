# -*- coding: utf-8 -*-
class IndexController < ApplicationController
  before_filter :login_required
  
  def index
    if current_user.is_admin?
      return redirect_to "/admin"
    end
    redirect_to '/dashboard'
  end

  def dashboard
    # 教师和学生的工作台页面
  end

  def user_complete_search
    # user_ids = User.complete_search(params[:q]).map { |doc|
    #   doc['id']
    # }[0...10]

    # @users = user_ids.map{ |user_id|
    #   User.find_by_id(user_id)
    # }.compact.uniq
    @users = User.all

    render :partial => 'complete_search/user'
  end

  def check_tip_messages
    render :json => {
      :questions_count => current_user.question_tip_message.count,
      :answers_count => current_user.answer_tip_message.count,
      :announcements_count => current_user.unread_announcements.count,
      :media_shares_count => current_user.media_share_tip_message.count,
      :comments_count => current_user.comment_tip_message.count,
      :short_messages_count => current_user.unread_messages.count
    }
  end

  def batch_destroy
    model = params[:model] ? params[:model].constantize : nil
    ids   = params[:ids] ? params[:ids].gsub(/\s+/, '').split(',') : []

    if model
      model.find(ids).each do |instance|
        instance.destroy if instance.destroyable_by?(current_user)
      end
    end

    redirect_to :back
  end
end
