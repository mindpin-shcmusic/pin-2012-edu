class SliceTempFilesController < ApplicationController
  before_filter :login_required

  def upload
    slice_temp_file_id = params[:slice_temp_file_id]
    file_name = params[:name]
    file_size = params[:size]
    blob = params[:blob]

    # 有 slice_temp_file_id，说明是上传后续分段
    if !!slice_temp_file_id
      slice_temp_file = SliceTempFile.find(slice_temp_file_id)
      slice_temp_file.save_new_blob(blob)
      return render :json => {
        :saved_size => slice_temp_file.saved_size 
      }
    end

    old_slice_temp_file = SliceTempFile.get_from_blob(current_user, file_name, file_size, blob)
    if !old_slice_temp_file.blank?
      return render :json => {
        :slice_temp_file_id => old_slice_temp_file.id,
        :saved_size => old_slice_temp_file.saved_size
      }
    end

    new_slice_temp_file = SliceTempFile.create_by_params(file_name, file_size, current_user)
    new_slice_temp_file.save_new_blob(blob)
    render :json=>{
      :slice_temp_file_id => new_slice_temp_file.id,
      :saved_size => new_slice_temp_file.saved_size
    }
  end

end
