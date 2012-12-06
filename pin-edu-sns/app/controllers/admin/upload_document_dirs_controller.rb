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
    create_resource_ajax UploadDocumentDir.new(params[:upload_document_dir]), 
                         :partial => '/admin/upload_document_dirs/parts/cells'    
  end
  
  
end
