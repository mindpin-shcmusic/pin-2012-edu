# -*- coding: utf-8 -*-
class Admin::CoursesController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :per_load

  def per_load
    @course = Course.find(params[:id]) if params[:id]  
  end
  
  def search
    @result = Course.search params[:query]

    render :partial => 'course_list', :locals => {:courses => @result}, :layout => false
  end

  def index
    @courses = Course.paginated(params[:page])
  end
  
  def new
    @course = Course.new
  end
  
  def create
    @course = Course.new(params[:course])
    if @course.save
      return redirect_to "/admin/courses/#{@course.id}"
    end
    
    error = @course.errors.first
    flash[:error] = error[1]
    redirect_to "/admin/courses/new"
  end

  # for ajax
  def destroy
    @course.remove
    render :text => 'ok'
  end

  def edit
  end

  def update
    if @course.update_attributes params[:course]
      return redirect_to "/admin/courses/#{@course.id}"
    end
    error = @course.errors.first
    flash[:error] = error[1]
    redirect_to "/admin/courses/#{@course.id}/edit"
  end
  
  def show
  end

  def select_students
  end
  
  def set_students
    student_user_ids = params[:student_user_ids].split(',')
    @course.student_user_ids = student_user_ids
    redirect_to "/admin/courses/#{@course.id}"
  end

  def import_from_csv_page
  end

  def import_from_csv
    Course.import_from_csv(params[:csv_file])
    redirect_to "/admin/courses"
  rescue Exception=>ex
    flash[:error] = ex.message
    redirect_to "/admin/courses/import_from_csv_page"
  end

  def upload_image_page
  end

  def upload_image
    @course.course_images.create :file_entity_id => params[:file_entity_id]
    render :text => '图片上传成功'
  end

  def delete_image
    CourseImage.find(params[:course_image_id]).destroy
    render :text => '图片已删除'
  end

  def select_cover_page
  end

  def select_cover
    course_image = @course.course_images.find(params[:course_image_id])
    @course.cover = course_image
    @course.save
    render :text => '封面选择成功'
  end

  def add_teacher_page
  end

  def add_teacher
    users = params[:user_ids].map{|id|User.find(id)}
    semester = Semester.now
    users.each do |user|
      @course.add_teacher(
        :semester => semester,
        :teacher_user => user
      )
    end
    redirect_to "/admin/courses/#{@course.id}"
  end

end
