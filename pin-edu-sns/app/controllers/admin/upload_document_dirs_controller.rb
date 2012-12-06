# -*- coding: utf-8 -*-
class Admin::UploadDocumentDirsController < ApplicationController
  layout 'admin'
  before_filter :login_required

  def index
    @dir_id = params['dir_id'] || 0

    # 目的
    dir = UploadDocumentDir.get_by_id(@dir_id)
    @dirs = dir.sub_dirs
    @documents = dir.documents
  end

  def create_folder
    dir = UploadDocumentDir.create(params[:upload_document_dir])

    return render :partial => '/admin/upload_document_dirs/parts/dirs', 
                  :locals => {:dirs => [dir]}

  rescue
    render :status => 422, :text => '请填写正确的文件名'
  end
  
  
end
