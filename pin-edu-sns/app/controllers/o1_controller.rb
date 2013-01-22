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
end
