class Admin::SearchController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :search_count
  def search_count
    @query = params[:query]

    @teachers_count = Teacher.search_count @query
    @students_count = Student.search_count @query
    @courses_count = Course.search_count @query
    @teams_count = Team.search_count @query
    @media_resources_count = MediaResource.search_count @query
    @tag_media_reources_count = MediaResource.with_tag_name(@query).count
    
    @all_count = @teachers_count + @students_count + @courses_count + @teams_count + @media_resources_count + @tag_media_reources_count
  end

  def index
    @teachers = Teacher.search @query, :per_page => 3, :page => 1
    @students = Student.search @query, :per_page => 3, :page => 1
    @courses = Course.search @query, :per_page => 3, :page => 1
    @teams = Team.search @query, :per_page => 3, :page => 1
    @media_resources = MediaResource.search @query, :per_page => 3, :page => 1
    @tag_media_reources = MediaResource.with_tag_name(@query).paginate(:per_page => 3, :page => 1)
  end

  def show
    query = params[:query]
    case params[:kind]
    when 'teacher'
      search_teacher
    when 'student'
      search_student
    when 'course'
      search_course
    when 'team'
      search_team
    when 'media_resource'
      search_media_resource
    when 'tag_media_resource'
      search_tag_media_resource
    else
      render_status_page 404, "页面不存在"
    end
  end

  def search_teacher
    @teachers = Teacher.search @query, :per_page => params[:per_page]||30, :page => params[:page]||1
    render :template => "/admin/search/search_teacher"
  end

  def search_student
    @students = Student.search @query, :per_page => params[:per_page]||30, :page => params[:page]||1
    render :template => "/admin/search/search_student"
  end

  def search_course
    @courses = Course.search @query, :per_page => params[:per_page]||30, :page => params[:page]||1
    render :template => "/admin/search/search_course"
  end

  def search_team
    @teams = Team.search @query, :per_page => params[:per_page]||30, :page => params[:page]||1
    render :template => "/admin/search/search_team"
  end

  def search_media_resource
    @media_resources = MediaResource.search @query, :per_page => params[:per_page]||30, :page => params[:page]||1
    render :template => "/admin/search/search_media_resource"
  end

  def search_tag_media_resource
    @tag_media_reources = MediaResource.with_tag_name(@query).paginate(:per_page => params[:per_page]||30, :page => params[:page]||1)
    render :template => "/admin/search/search_tag_media_resource"
  end
end