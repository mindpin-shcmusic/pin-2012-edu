# -*- coding: utf-8 -*-
class CourseImagesController < ApplicationController
  before_filter :login_required

  def create
    CourseImage.create :file_entity_id => params[:file_entity_id], :course_id => params[:course_id], :name => params[:name], :creator => current_user
    render :text => '图片上传成功'
  end

  def destroy
    CourseImage.find(params[:id]).destroy
    render :text => '图片已删除'
  end

  def show
    @resource = CourseImage.find(params[:id])
    render :template => 'courses/resource_show'
  end

end
