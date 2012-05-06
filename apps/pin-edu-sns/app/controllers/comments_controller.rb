class CommentsController < ApplicationController
  before_filter :login_required

  def create
    @comment = Comment.new(params[:comment])
    @comment.save
    redirect_to MediaFile.find(@comment.model_id)
  end
end
