class G1Controller < ApplicationController
  def show
    @homeworks = Homework.limit(10)
  end
end