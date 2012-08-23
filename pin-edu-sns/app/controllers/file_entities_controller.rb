class FileEntitiesController < ApplicationController
  include DownloadHelper
  before_filter :login_required,:only=>[:upload]

  def upload
    file_entity_id = params[:file_entity_id]
    file_name = params[:name]
    file_size = params[:size]
    blob = params[:blob]

    if file_entity_id.blank?
      file_entity = FileEntity.create_by_params(file_name,file_size,blob)
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
    item = get_download_item_by_download_id(params[:download_id])
    file_entity = FileEntity.find(item.file_entity_id)
    send_file file_entity.attach.path, :type => file_entity.attach_content_type, :disposition => 'attachment',
      :filename => item.real_file_name
  end

  def re_encode
    file_entity = FileEntity.find(params[:id])
    file_entity.into_video_encode_queue
    render :partial => 'aj/file_entity_preview', :locals => {:file_entity => file_entity}
  end
end