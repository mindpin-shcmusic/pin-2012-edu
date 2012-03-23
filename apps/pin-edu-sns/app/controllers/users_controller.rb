class UsersController < ApplicationController
  def show
    if current_user.id == params[:id] then
      # 当前用户发起的投票
      @current_user_votes = current_user.votes.all
      
      # 当前用户参与过的投票
      @voted_by_current_user = current_user.vote_results.all
      
      # 当前用户发起的问题
      @asked_questions = current_user.asked_questions
      
      # 当前用户回答过的问题列表
      @answered_questions = current_user.answered_questions
      
      # 用户活动
      @week_activities_data = current_user.the_week_activities_data
      
      # 媒体
      @current_user_media_files = current_user.media_files.all
      
      # 如果是老师，则显示创建的作业列表
      if current_user.is_teacher?
        @teacher_homeworks = current_user.homeworks
      end
      
      # 如果是学生，则显示被分配的作业列表
      if current_user.is_student?
        @student_homeworks = current_user.homework_assigns
      end

    else
      other_user = User.find(params[:id])
      
      # 当前用户发起的投票
      @other_user_votes = other_user.votes.all
      
      # 当前用户参与过的投票
      @voted_by_other_user = other_user.vote_results.all
      
      # 当前用户发起的问题
      @asked_questions = other_user.asked_questions
      
      # 当前用户回答过的问题列表
      @answered_questions = other_user.answered_questions
      
      # 用户活动
      @week_activities_data = other_user.the_week_activities_data
      
      # 媒体
      @other_user_media_files = other_user.media_files
      
      # 如果是老师，则显示创建的作业列表
      if other_user.is_teacher?
        @teacher_homeworks = current_user.homeworks
      end
      
      # 如果是学生，则显示被分配的作业列表
      if other_user.is_student?
        @student_homeworks = current_user.homework_assigns
      end
      
      render :action => 'show_other'
    end
    
  end

end
