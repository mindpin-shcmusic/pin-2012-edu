# -*- coding: utf-8 -*-
class AnswersController < ApplicationController
  before_filter :login_required
  before_filter :per_load
  def per_load
    @answer = Answer.find(params[:id]) if params[:id]
    @question = Question.find(params[:question_id]) if params[:question_id]

    if current_user.is_student?
      redirect_to :back
    end
  end

  def create
    @answer = current_user.answers.build(params[:answer])
    @answer.question = @question
    if @answer.save
      return redirect_to "/questions"
    end
    
    error = @question.errors.first
    flash[:error] = error[1]
    redirect_to :back
  end


  def update
    if @answer.update_attributes(params[:answer])
      return redirect_to :back
    end

    error = @answer.errors.first
    flash[:error] = error[1]
    redirect_to :back
  end


end
