class TagsController < ApplicationController
  def show
    @media_resources = MediaResource.tagged_with(params[:tag_name]).of_creator(current_user)
  end
end