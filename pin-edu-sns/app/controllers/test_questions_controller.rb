# -*- coding: utf-8 -*-
class TestQuestionsController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @test_question  = TestQuestion.find params[:id] if params[:id]
  end


  def index
    @test_questions = sort_scope(TestQuestion).
      paginate(:page => params[:page], :per_page => 20)
  end

  def new
    @test_question = TestQuestion.new
  end

  def create
    @test_question = TestQuestion.new(params[:test_question])
    if @test_question.save
      return redirect_to "/admin/test_questions/#{@test_question.id}"
    end
    
    error = @test_question.errors.first
    flash[:error] = error[1]
    redirect_to "/admin/test_questions/new"
  end

  def show
  end

  def edit
  end

  def update
    if @test_question.update_attributes params[:test_question]
      return redirect_to "/admin/test_questions/#{@test_question.id}"
    end
    error = @test_question.errors.first
    flash[:error] = error[1]
    redirect_to "/admin/test_questions/#{@test_question.id}/edit"
  end

  def destroy
    @test_question.destroy
  end

end
