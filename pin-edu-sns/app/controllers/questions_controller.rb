# -*- coding: utf-8 -*-
class QuestionsController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @question  = Question.find params[:id] if params[:id]
  end

  def index
    questions = Question.paginated(params[:page])
    @questions = filter questions do
      all        {:default}
      answered   {questions.answered}
      unanswered {questions.unanswered}
    end
  end


  def new
  end

  def create
    create_resource current_user.questions.build(params[:question])
  end

  def edit
    if @question.has_answered
      return redirect_to "/questions"
    end
  end


  def update
    if @question.has_answered
      return redirect_to "/questions"
    end

    if @question.update_attributes(params[:question])
      return redirect_to "/questions"
    end

    error = @question.errors.first
    flash[:error] = error[1]
    redirect_to "/questions"
  end


  def show
    if current_user.is_student? && @question.answer
      current_user.answer_tip_message.delete(@question.answer.id)
    end

    current_user.question_tip_message.delete(@question.id) if current_user.is_teacher?    
  end
  

  def destroy
    if current_user == @question.creator || current_user == @question.teacher_user
      @question.remove
    end
    render :text => 'ok'
  end

end
