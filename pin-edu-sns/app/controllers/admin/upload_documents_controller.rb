# -*- coding: utf-8 -*-
class Admin::UploadDocumentsController < ApplicationController
  layout 'admin'
  before_filter :login_required

  def new
    @dir_id = params['dir_id'] || 0
  end

  def show
    @upload_document = UploadDocument.find(params[:id])
  end

  def create
    create_resource UploadDocument.new(params[:upload_document])
  end

  def file_put
    document = UploadDocument.create_by_upload(params[:upload_document])

    return render :partial => 'admin/upload_document_dirs/parts/documents',
                  :locals => {
                    :documents => [document]
                  }
  end
end
