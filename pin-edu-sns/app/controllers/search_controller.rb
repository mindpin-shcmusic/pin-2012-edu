class SearchController < ApplicationController
  before_filter :login_required
  before_filter :search_count
  def search_count
    @query = params[:query]

    @media_resources_count = MediaResource.search_count(@query,
      :conditions => {:creator_id => current_user.id, :is_removed => 0})

    @media_shares_count = MediaShare.search_count(@query,
      :conditions => {:receiver_id => current_user.id})

    @public_resources_count = PublicResource.search_count(@query,
      :conditions => {:creator_id => current_user.id})

    @all_count = @media_resources_count + @media_shares_count + @public_resources_count
  end

  def index
    @media_resources = MediaResource.search(@query,
      :conditions => {:creator_id => current_user.id, :is_removed => 0},
      :per_page => 3, :page => 1)

    @media_shares = MediaShare.search(@query,
      :conditions => {:receiver_id => current_user.id},
      :per_page => 3, :page => 1)

    @public_resources = PublicResource.search(@query,
      :conditions => {:creator_id => current_user.id},
      :per_page => 3, :page => 1)
  end

  def show
    query = params[:query]
    case params[:kind]
    when 'media_resource'
      search_media_resource
    when 'media_share'
      search_media_shares
    when 'public_resource'
      search_public_resource
    else
      render_status_page 404, "页面不存在"
    end
  end

  def search_media_resource
    @media_resources = MediaResource.search(@query,
      :conditions => {:creator_id => current_user.id, :is_removed => 0},
      :per_page => params[:per_page]||30, :page => params[:page]||1)
    render :template => "/search/search_media_resource"
  end

  def search_media_shares
    @media_shares = MediaShare.search(@query,
      :conditions => {:receiver_id => current_user.id},
      :per_page => params[:per_page]||30, :page => params[:page]||1)
    render :template => "/search/search_media_share" 
  end

  def search_public_resource
    @public_resources = PublicResource.search(@query,
      :conditions => {:creator_id => current_user.id},
      :per_page => params[:per_page]||30, :page => params[:page]||1)
    render :template => "/search/search_public_resource" 
  end

end