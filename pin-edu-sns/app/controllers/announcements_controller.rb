class AnnouncementsController < ApplicationController
  before_filter :login_required
  before_filter :not_for_students, :only => [:new, :create, :announce, :mine]

  def new
    @announcement = current_user.created_announcements.build
  end

  def index
    tab = params[:tab]

    case tab
    when 'received'
      @announcements = sort_scope(current_user.received_announcements).paginated(params[:page])
    when 'unread'
      @announcements = current_user.unread_announcements.paginated(params[:page])
    when 'mine'
      @announcements = sort_scope(current_user.created_announcements).paginated(params[:page])
    else
      @announcements = sort_scope(current_user.received_announcements).paginated(params[:page])
    end

  end



  def create
    @announcement = current_user.created_announcements.build params[:announcement]
    if @announcement.save
      courses = (params[:course_ids]||'').split(',')
      @announcement.announce_to(:courses => courses)
      return redirect_to @announcement 
    end
    render :action => :new
  end



  def show
    @announcement = Announcement.find(params[:id])
    @announcement.read_by!(current_user) if current_user != @announcement.creator
  end

protected

  def not_for_students
    redirect_to announcements_path if current_user.is_student?
  end

end
