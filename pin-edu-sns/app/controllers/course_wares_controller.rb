class CourseWaresController < ApplicationController
  before_filter :login_required
  before_filter :per_load
  def per_load
    @chapter = Chapter.find params[:chapter_id] if params[:chapter_id]
    @course_ware = CourseWare.find params[:id] if params[:id]
    if @chapter.blank? && !@course_ware.blank?
      @chapter = @course_ware.chapter 
    end
  end

  def create
    @course_ware = @chapter.course_wares.build(:creator => current_user)
    if @course_ware.save
      return render :partial => '/chapters/parts/course_ware', :locals => {
        :course_ware => @course_ware
      }
    end

    error = @course_ware.errors.first[1]
    render :text => error, :status => 422
  end

  def update_title
    @course_ware.update_attribute(:title,params[:content])
    render :text => @course_ware.title
  end

  def update_desc
    @course_ware.update_attribute(:desc,params[:content])
    render :text => @course_ware.desc
  end

  def upload_file
    file_entity = FileEntity.find(params[:file_entity_id])
    file_name = params[:file_name]

    @course_ware.upload_file(file_entity, file_name, current_user)

    render :partial => '/chapters/parts/resource',
      :locals => {:resource => @course_ware.media_resource}
  end

  def link_file
    media_resource = MediaResource.find(params[:media_resource_id])
    @course_ware.link_file(media_resource)    

    render :partial => '/chapters/parts/resource',
      :locals => {:resource => @course_ware.media_resource}
  end
end