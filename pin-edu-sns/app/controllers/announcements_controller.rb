class AnnouncementsController < ApplicationController
  before_filter :login_required
  before_filter :not_for_students, :only => [:new, :create, :announce]

  def new
    @announcement = current_user.created_announcements.build
  end

  def index
    @announcements = current_user.received_announcements
  end

  def create
    @announcement = current_user.created_announcements.build params[:announcement]
    return redirect_to @announcement if @announcement.save
    render :action => :new
  end

  def received
    @announcements = current_user.unread_announcements
  end

  def show
    @announcement = Announcement.find(params[:id])
    @announcement.read_by!(current_user) if current_user != @announcement.creator
  end

  def announce
    courses = params[:course_ids] || []
    teams = params[:team_ids] || []

    @announcement = Announcement.find(params[:id])
    @announcement.announce_to(:courses => courses, :teams => teams)
    redirect_to :back
  end

  def read
    Announcement.find(params[:id]).read_by!(current_user)
    redirect_to :back
  end

protected

  def not_for_students
    redirect_to received_announcements_path if current_user.is_student?
  end

end
