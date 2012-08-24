# encoding: utf-8

class MediaResourcesController < ApplicationController
  before_filter :login_required

  def index
    @dir = nil
    @media_resources = current_user.media_resources.root_res.web_order
    render :action => 'index'
  end

  def file
    resource_path = Base64Plus.decode64(params[:path])
    current_resource = MediaResource.get(current_user, resource_path)

    if current_resource.is_dir?
      @current_dir = current_resource
      @media_resources = @current_dir.media_resources.web_order
      return render :action => 'index'
    end
    
    if current_resource.is_file?
      return send_file current_resource.attach.path
    end
  end

  def upload_file
    file_entity = FileEntity.find(params[:file_entity_id])
    resource_path = URI.decode(request.fullpath).sub('/file_put', '')

    MediaResource.put_file_entity(current_user, resource_path, file_entity)
    
    resource = MediaResource.get(current_user, resource_path)
    return render :partial => '/media_resources/parts/resources.html.haml',
                  :locals => {
                    :resources => [resource]
                  }
  end

  # for ajax
  def create_folder
    if params[:folder].match(/^([A-Za-z0-9一-龥\-\_\.]+)$/)
      resource_path = File.join(params[:current_path], params[:folder])
      resource = MediaResource.create_folder(current_user, resource_path)

      if resource.blank?
        return render :status => 401,
                      :text => '文件夹创建失败'
      end

      return render :partial => '/media_resources/parts/resources',
                    :locals => {
                      :resources => [resource]
                    }
    end

    render :status => 401,
           :text => '文件夹名不符合规范'

  rescue MediaResource::RepeatedlyCreateFolderError
    render :status => 401,
           :text => '文件夹名重复'
  end

  def destroy
    resource_path = URI.decode(request.fullpath).sub('/file', '')
    MediaResource.get(current_user, resource_path).remove

    render :text => 'ok'
  end

  # 搜索当前登录用户资源
  def search
    @keyword = params[:keyword]
    @media_resources = MediaResource.search(@keyword, 
      :conditions => {:creator_id => current_user.id, :is_removed => 0}, 
      :page => params[:page], :per_page => 20)

  end

  def edit_tag
    resource_path = "/#{params[:path]}"
    @media_resource = MediaResource.get(current_user, resource_path)
  end

  def update_tag
    resource_path = "/#{params[:path]}"
    @media_resource = MediaResource.get(current_user, resource_path)
    @media_resource.tag_list = params[:tag_names]
    @media_resource.save
    render :json=>@media_resource.tags.map{|tag|tag.name}
  end

  def file_show
    resource_path = Base64Plus.decode64(params[:path])
    @media_resource = MediaResource.get(current_user, resource_path)
  end

  def lazyload_sub_dynatree
    @media_resource = MediaResource.get(current_user, params[:parent_dir])
    @current_resource = MediaResource.get(current_user, params[:current_resource_path])
    render :json => @media_resource.lazyload_sub_dynatree(@current_resource)
  end

  def reload_dynatree
    if params[:dir].blank?
      data = MediaResource.root_dynatree(current_user)
    else
      media_resource = MediaResource.get(current_user, params[:dir])
      data = media_resource.preload_dynatree
    end
    render :json => data
  end

  def move
    @media_resource = MediaResource.get(current_user, params[:current_resource_path])
    
    if @media_resource.move(params[:to_dir])
      return render :partial=>'move',:locals=>{:media_resource => @media_resource}
    end
    render :status=>422, :text => @media_resource.errors[:dir_id].first
  end

end
