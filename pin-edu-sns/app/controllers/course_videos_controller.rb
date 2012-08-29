# -*- coding: utf-8 -*-
class CourseVideosController < ApplicationController
  before_filter :login_required

  def create
    CourseVideo.create :file_entity_id => params[:file_entity_id], :course_id => params[:course_id]
    render :text => '视频上传成功'
  end

  def destroy
    CourseVideo.find(params[:course_video_id]).destroy
    render :text => '视频已删除'
  end

end
