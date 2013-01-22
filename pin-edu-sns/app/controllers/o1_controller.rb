# -*- coding: utf-8 -*-
require 'question_demo'

class O1Controller < ApplicationController
  def zhaoyun
    @questions = ZYQuestions
    render 'o1/index'
  end

  def zhugeliang
    @questions = DemoQuestions
    render 'o1/index'
  end

  def faq_form
    @question = ZYQuestions.first
    @courses = ['Java程序设计', 'Java EE & Android开发培训课程', 'Javascript & jQuery培训课程']
  end

  def question
    @question = ZYQuestions[2]
    @answers = case params[:step]
               when '1'
                 DemoAnswers[2..2]
               when '2'
                 DemoAnswers[1..2]
               when '3'
                 DemoAnswers[0..2]
               else
                 DemoAnswers
               end
    @zyq_comments = ZYQComments
  end
end
