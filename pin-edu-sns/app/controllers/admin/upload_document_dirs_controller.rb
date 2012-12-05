# -*- coding: utf-8 -*-
class Admin::UploadDocumentDirsController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @dir_id = 0
    @dir_id = params['dir_id'] if params['dir_id']
  end

  def index
    @upload_document_dirs = sort_scope(UploadDocumentDir).sub_dirs(@dir_id).
                            web_order.paginated(params[:page])

    @texts = UploadDocument.dir_texts(@dir_id)

    @files = UploadDocument.dir_files(@dir_id)
  end


  def file
  end


  def create_folder
    if params[:folder].match(/^([A-Za-z0-9一-龥\-\_\.]+)$/)

      doc = UploadDocumentDir.create(:dir_id => params[:dir_id], :name => params[:folder])

      return render :partial => '/admin/upload_document_dirs/parts/dirs', 
                    :locals => {:upload_document_dirs => [doc]}
    end
  end
  
  
end
