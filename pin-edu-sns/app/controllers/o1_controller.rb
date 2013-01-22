# -*- coding: utf-8 -*-
require 'question_demo'

class O1Controller < ApplicationController
  def zhaoyun
    @questions = DemoModel::STUDENT_QUESTIONS
    render 'o1/index'
  end

  def zhugeliang
    @questions = DemoModel::TEACHER_QUESTIONS
    render 'o1/index'
  end

  def faq_form
    @question = DemoModel::STUDENT_QUESTIONS[0]
    @courses = DemoModel::COURSES
  end

  def question
    @question = DemoModel::STUDENT_QUESTIONS[0]
    @answers = case params[:step]
                when '1'
                  @question.answers[2..2]
                when '2'
                  @question.answers[1..2]
                else
                  @question.answers
               end
  end
end
