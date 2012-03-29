class TagsController < ApplicationController
  def add_tag
    @vote = Vote.find(params[:model_id]) if params[:model_id]
    @vote.add_tag(current_user,params[:name])
    redirect_to @vote
  end

  def update_tags
  end
  
  def remove_tag
    @vote = Vote.find(params[:model_id]) if params[:model_id]
    @vote.remove_tag(params[:tag])
    redirect_to @vote
  end
  
  def create_tag
  end

end
