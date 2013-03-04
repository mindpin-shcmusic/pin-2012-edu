class Admin::CourseResourcesController < ApplicationController
  before_filter :login_required

  def create
    resource = CourseResource.create(
      :file_entity_id => params[:file_entity_id],
      :course_id => params[:course_id],
      :name => params[:name],
      :kind => params[:kind].upcase,
      :semester => Semester.get_by_value(params[:semester_value]),
      :creator => current_user)

    render :partial =>'/admin/courses/parts/resource', :locals => {:course_resource => resource}
  end

  def destroy
    CourseResource.find(params[:id]).destroy
    render :text => '资源已删除'
  end

end
