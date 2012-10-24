class CourseResourcesController < ApplicationController
  before_filter :login_required

  def create
    CourseResource.create(
      :file_entity_id => params[:file_entity_id],
      :course_id => params[:course_id],
      :name => params[:name],
      :kind => params[:kind].upcase,
      :semester => Semester.now,
      :creator => current_user)
    render :text => '资源上传成功'
  end

  def destroy
    CourseResource.find(params[:id]).destroy
    render :text => '资源已删除'
  end

  def show
    @resource = CourseResource.find(params[:id])
    render :template => 'courses/resource_show'
  end

end
