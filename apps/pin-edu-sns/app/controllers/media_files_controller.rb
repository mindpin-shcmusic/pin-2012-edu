class MediaFilesController < ApplicationController
  before_filter :login_required, :except => [:create_by_edu, :encode_complete, :file_merge_complete]

  # 我的资源
  def mine
    @kind = params[:kind]
    category_id = params[:category_id]
    @current_category = category_id.blank? ? nil : Category.find(category_id)

    @media_files = current_user.media_files.with_kind(@kind).paginate(:per_page=>50, :page=>1)

    if request.headers['X-PJAX']
      render :layout => false
    end

  end


  def index
    @level1_categories = Category.roots
    # @current_category = Category.find(params[:category_id]) if params[:category_id]
    if params[:index_alt]
      render :template => "media_files/index_alt"
    end
  end

  def new
    @media_file = MediaFile.new
  end
  
  def create
    @media_file = MediaFile.create(:category_id=>nil,:file=>params[:files],:place=>MediaFile::PLACE_OSS,:creator=>current_user)
    redirect_to @media_file
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.js do
        render :text => e.message, :status => 403
      end
    end
  end

  def show
    @media_file = MediaFile.find(params[:id])
  end

  def update
    @media_file = MediaFile.find(params[:id])
    if @media_file.update_attributes(params[:media_file])
      render :json => "oh yeah!"
    else
      render :json => @media_file.errors, :status => 406
    end
  end

  def create_by_edu
    video_encode_status = params[:video_encode_status]||""
    @media_file = MediaFile.new(
      :entry_file_name=>params[:name],
      :entry_content_type=>params[:type],
      :entry_file_size=>params[:size],
      :entry_updated_at=>Time.now,
      :place=>MediaFile::PLACE_EDU,
      :video_encode_status=>video_encode_status,
      :creator_id=>params[:creator_id])
      
    if @media_file.save
#      return render :text=>pin_url_for("sns","/media_files/#{@media_file.id}")
      return render :json => @media_file
    end
    render :text=>@media_file.errors.first[1],:status=>422  
  end
  
  def encode_complete
    @media_file = MediaFile.find(params[:id])
    @media_file.video_encode_status = params[:result]
    @media_file.save
    render :text=>"success"
  end
  
  def lifei_list
    @media_files = MediaFile.all
  end

  def file_merge_complete
    @media_file = MediaFile.find(params[:id])
    @media_file.file_merged = true
    @media_file.save
    render :text=>"success"
  end

end