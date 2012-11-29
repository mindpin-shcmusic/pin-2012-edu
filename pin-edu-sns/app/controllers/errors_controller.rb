class ErrorsController < ApplicationController
  def show
    raise request.env[:exception]
  end
end