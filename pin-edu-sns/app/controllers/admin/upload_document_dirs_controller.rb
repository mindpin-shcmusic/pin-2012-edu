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
    @upload_document_dirs = sort_scope(UploadDocumentDir).root_res.web_order.paginated(params[:page])
  end


  def file
    resource_path = Base64Plus.decode64(params[:path])
    current_resource = UploadDocumentDir.get(current_user, resource_path)

    if current_resource.is_dir?
      @current_dir = current_resource
      @media_resources = @current_dir.media_resources.web_order
      return render :action => 'index'
    end
    
    if current_resource.is_file?
      return send_file current_resource.attach.path
    end
  end

  def new
  end

  def create_folder
    if params[:folder].match(/^([A-Za-z0-9一-龥\-\_\.]+)$/)
      UploadDocumentDir.new(:dir_id => params[:dir_id], :name => params[:folder])
      return sort_scope(UploadDocumentDir).root_res.web_order.paginated(params[:page])
    end

  end
  
  
end
