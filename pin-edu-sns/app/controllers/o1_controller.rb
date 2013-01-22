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
end
