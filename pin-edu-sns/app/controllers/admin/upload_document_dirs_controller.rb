# -*- coding: utf-8 -*-
class Admin::UploadDocumentDirsController < ApplicationController
  layout 'admin'
  before_filter :login_required

  def pre_load
  end

  def index
    @upload_document_dirs = sort_scope(UploadDocumentDir).
    root_res.web_order.paginated(params[:page])
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
      resource_path = File.join(params[:current_path], params[:folder])
      resource = UploadDocumentDir.create_folder(resource_path)

      if resource.blank?
        return render :status => 422,
                      :text => '文件夹创建失败'
      end

  end

    render :status => 422,
           :text => '文件夹名不符合规范'

  rescue UploadDocumentDir::RepeatedlyCreateFolderError
    render :status => 422,
           :text => '文件夹名重复'
  end
  
  
end
