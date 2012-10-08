# -*- coding: utf-8 -*-
class QuestionsController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @question  = Question.find params[:id] if params[:id]
  end

  def index
    @questions = Question.paginate(:page => params[:page])
  end


  def new
  end

  def create

    @question = current_user.questions.build(params[:question])
    if @question.save
      return redirect_to "/questions"
    end
    
    error = @question.errors.first
    flash[:error] = error[1]

    redirect_to "/questions/new"
  end


  def update
    if @question.update_attributes(params[:question])
      return redirect_to :back
    end

    error = @question.errors.first
    flash[:error] = error[1]
    redirect_to "/questions/#{@question.id}/edit"
  end


  def show
  end
  

  def destroy
  end

end
