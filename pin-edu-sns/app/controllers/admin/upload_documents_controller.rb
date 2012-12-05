# -*- coding: utf-8 -*-
class Admin::UploadDocumentsController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @upload_document = UploadDocument.find(params[:id]) if params[:id]

    @dir_id = 0
    @dir_id = params['dir_id'] if params['dir_id']
  end


  def new
    @upload_document = UploadDocument.new
  end

  def create
    create_resource UploadDocument.new(params[:upload_document])
  end

  def show
  end
  
  
end
