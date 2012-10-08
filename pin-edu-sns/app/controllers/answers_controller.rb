# -*- coding: utf-8 -*-
class AnswersController < ApplicationController
  before_filter :login_required


  def create
    @answer = current_user.answers.build(params[:answer])
    @answer.question = Question.find(params[:question_id])
    if @answer.save
      return redirect_to "/questions"
    end
    
    error = @question.errors.first
    flash[:error] = error[1]
    redirect_to :back
  end


end
