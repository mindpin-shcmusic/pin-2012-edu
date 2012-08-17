class TagsController < ApplicationController
  before_filter :login_required

  def show
  end

  def show_mine
    @media_resources = MediaResource.tagged_with(params[:tag_name]).of_creator(current_user)
    render :action=>:show
  end

  def show_public
    @media_resources = MediaResource.tagged_with(params[:tag_name]).public_share
    render :action=>:show
  end

  def show_shared
    @media_resources = current_user.received_shared_media_resources.tagged_with(params[:tag_name])
    render :action=>:show
  end
end