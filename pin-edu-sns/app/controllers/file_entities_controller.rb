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
    file_entity_id = get_file_entity_id_by_download_id(params[:download_id])
    file_entity = FileEntity.find(file_entity_id)
    send_file file_entity.attach.path
  end
end