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

    @tag_media_resources_count = MediaResource.tagged_with(@query).of_creator(current_user).count
    @tag_public_media_resources_count = MediaResource.tagged_with(@query).public_share.count
    @tag_share_media_resources_count = current_user.received_shared_media_resources.tagged_with(@query).count
    @courses_count = Course.search_count @query
    @students_count = Student.search_count @query
    @teachers_count = Teacher.search_count @query

    @all_count = @media_resources_count + @media_shares_count + @public_resources_count +
      @tag_media_resources_count + @tag_public_media_resources_count + @tag_share_media_resources_count +
      @courses_count + @students_count + @teachers_count
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

    @tag_media_resources = MediaResource.tagged_with(@query).of_creator(current_user).paginate(:per_page => 3, :page => 1)
    @tag_public_media_resources = MediaResource.tagged_with(@query).public_share.paginate(:per_page => 3, :page => 1)
    @tag_share_media_resources = current_user.received_shared_media_resources.tagged_with(@query).paginate(:per_page => 3, :page => 1)
    @courses = Course.search @query, :per_page => 3, :page => 1
    @students = Student.search @query, :per_page => 3, :page => 1
    @teachers = Teacher.search @query, :per_page => 3, :page => 1
  end

  def show
    query = params[:query]
    case params[:kind]
    when 'media_resource'
      search_media_resource
    when 'media_share'
      search_media_share
    when 'public_resource'
      search_public_resource
    when 'tag'
      search_tag
    when 'course'
      search_course
    when 'student'
      search_student
    when 'teacher'
      search_teacher
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

  def search_media_share
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

  def search_tag
    @tag_media_resources = MediaResource.tagged_with(@query).of_creator(current_user).paginate(:per_page => params[:per_page]||30, :page => params[:page]||1)

    @tag_share_media_resources = current_user.received_shared_media_resources.tagged_with(@query).paginate(:per_page => params[:per_page]||30, :page => params[:page]||1)

    @tag_public_media_resources = MediaResource.tagged_with(@query).public_share.paginate(:per_page => params[:per_page]||30, :page => params[:page]||1)

    render :template => "/search/search_tag"
  end

  def search_course
    @courses = Course.search @query, :per_page => params[:per_page]||30, :page => params[:page]||1
    render :template => "/search/search_course"
  end

  def search_student
    @students = Student.search @query, :per_page => params[:per_page]||30, :page => params[:page]||1
    render :template => "/search/search_student"
  end

  def search_teacher
    @teachers = Teacher.search @query, :per_page => params[:per_page]||30, :page => params[:page]||1
    render :template => "/search/search_teacher"
  end
end