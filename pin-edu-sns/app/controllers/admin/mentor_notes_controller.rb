# -*- coding: utf-8 -*-
class Admin::MentorNotesController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @mentor_note  = MentorNote.find params[:id] if params[:id]
  end

  def index
    @mentor_notes = MentorNote.paginate(:page => params[:page]).order('id DESC')
  end

  def new
  end

  def create
    @mentor_note = MentorNote.new(params[:mentor_note])
    if @mentor_note.save
      return redirect_to "/admin/mentor_notes/#{@mentor_note.id}"
    end
    
    error = @mentor_note.errors.first
    flash[:error] = error[1]
    redirect_to "/admin/mentor_notes/new"
  end

  def show
  end

  def edit
  end

  def update
    if @mentor_note.update_attributes(params[:mentor_note])
      return redirect_to "/admin/mentor_notes"
    end

    error = @mentor_note.errors.first
    flash[:error] = error[1]
    redirect_to :back
  end


  def destroy
    @mentor_note.remove
    render :text => 'ok'
  end
end