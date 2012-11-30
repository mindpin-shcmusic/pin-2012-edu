class FileEntitiesController < ApplicationController
  before_filter :login_required,:only=>[:upload]

  def upload
    file_entity_id = params[:file_entity_id]
    file_name = params[:name]
    file_size = params[:size]
    blob = params[:blob]

    if file_entity_id.blank?
      file_entity = FileEntity.create_by_params(file_name,file_size)
      file_entity.save_first_blob(blob)
    else
      file_entity = FileEntity.find(file_entity_id)
      file_entity.save_new_blob(blob)
    end

    return render :json => {
      :file_entity_id => file_entity.id,
      :saved_size => file_entity.saved_size
    }
  end

  def download
    item = FileEntityDownloadItem.new(params[:download_id])
    file_entity = FileEntity.find(item.file_entity_id)
    #redirect_to file_entity.http_url
    send_file file_entity.attach.path, :type => file_entity.attach_content_type, :disposition => 'attachment',
      :filename => item.real_file_name
  end

  def re_encode
    file_entity = FileEntity.find(params[:id])
    file_entity.into_video_encode_queue
    render :partial => 'aj/file_entity_preview', :locals => {:file_entity => file_entity}
  end


  def kindeditor_upload
    blob = params[:imgFile]
    file_name = params[:imgFile].original_filename
    file_size = File.size(params[:imgFile].path)

    file_entity = FileEntity.create_by_params(file_name,file_size)
    file_entity.sync_save(blob)
    render :json => {
      :error => 0,
      :url => file_entity.http_url
    }
  end
end