# -*- coding: utf-8 -*-
class MentorStudentsController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    return redirect_to '/' if current_user.is_teacher?
    @mentor_student  = MentorStudent.find params[:id] if params[:id]
    @mentor_note = MentorNote.find params[:mentor_note_id] if params[:mentor_note_id]
  end

  def index
    @mentor_notes = sort_scope(MentorNote).paginate(:page => params[:page]).order('id DESC')
  end

  def new
  end

  def create
    @mentor_student = current_user.mentor_students.build(params[:mentor_student])

    @mentor_student.mentor_note = @mentor_note
    if @mentor_student.save
      return redirect_to "/mentor_students"
    end
    
    error = @mentor_student.errors.first
    flash[:error] = error[1]
    redirect_to "/mentor_students/new?mentor_note_id=#{@mentor_note.id}"
  end


  def show
  end

  def edit
  end

  def update
    if @mentor_student.update_attributes(params[:mentor_student])
      return redirect_to "/mentor_students"
    end

    error = @mentor_student.errors.first
    flash[:error] = error[1]
    redirect_to "/mentor_students/#{@mentor_student.id}/edit"
  end
end
