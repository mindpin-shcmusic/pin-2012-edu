# -*- coding: utf-8 -*-
class MediaSharesController < ApplicationController
  def index
    # 共享给我的用户列表
    @shared_users = current_user.linked_sharers
  end

  def new
    resource_path = params[:resource_path].sub('/file', '')
    @media_resource = MediaResource.get(current_user, resource_path)

    if current_user.is_teacher?
      @scope_course_teachers = current_user.get_teacher_course_teachers(:semester => Semester.now)
      @student_users = current_user.get_students(:semester => Semester.now)
      @teacher_users = current_user.get_teachers_of_the_same_courses(:semester => Semester.now)
    else
      @scope_course_teachers = current_user.get_student_course_teachers(:semester => Semester.now)
      @student_users = current_user.get_students_of_the_same_teachers(:semester => Semester.now)
      @teacher_users = current_user.get_teachers(:semester => Semester.now)
    end

    @shared_course_teacher_ids = @media_resource.shared_course_teacher_ids
    @shared_student_user_ids = @media_resource.shared_student_user_ids
    @shared_teacher_user_ids = @media_resource.shared_teacher_user_ids
  end

  def create
    resource_path = params[:resource_path]
    media_resource = MediaResource.get(current_user, resource_path)

    expression = {}
    expression[:course_teacher_ids] = params[:course_teacher_ids].split(',')
    expression[:student_user_ids] = params[:student_user_ids].split(',')
    expression[:teacher_user_ids] = params[:teacher_user_ids].split(',')
    
    media_resource.share_to_expression expression.to_json

    redirect_to params[:resource_path].split(/\//)[0..-2].join('/')
  end

  # 分享给其它用户目录
  def share
    if params[:path].blank?

      @sharer = User.find(params[:user_id])
      @media_resources = current_user.shared_resources_from(@sharer)
      @prev = :base
      return
    end

    resource_path = Base64Plus.decode64(params[:path])
    
    @sharer = User.find(params[:user_id])
    @current_dir = MediaResource.get(@sharer, resource_path)
    @media_resources = @current_dir.media_resources.web_order
    @prev = @current_dir.dir
    @prev = @sharer if @prev.blank?
  end

end
