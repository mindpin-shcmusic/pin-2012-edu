class MediaFilesController < ApplicationController
  before_filter :login_required, :except => [:create_by_edu]
  def index
    @level1_categories = Category.roots
  end

  def new
    @media_file = MediaFile.new
  end
  
  def create
    @media_file = MediaFile.new(:category_id=>params[:media_file][:category_id],:file=>params[:media_file][:file],:place=>MediaFile::PLACE_OSS,:creator=>current_user,:uuid=>UUIDTools::UUID.random_create.to_s)
    if @media_file.save
      redirect_to "/media_files"
    else
      render :template => "media_files/new"
    end
  end
  
  def create_by_edu
    @media_file = MediaFile.new(
      :file_file_name=>params[:name],
      :file_content_type=>params[:type],
      :file_file_size=>params[:size],
      :file_updated_at=>Time.now,
      :uuid=>params[:uuid],
      :place=>MediaFile::PLACE_EDU,
      :creator_id=>params[:creator_id])
      
    if @media_file.save
      return render :text=>"success"
    end
    render :text=>@media_file.errors.first[1],:status=>422  
  end
end
