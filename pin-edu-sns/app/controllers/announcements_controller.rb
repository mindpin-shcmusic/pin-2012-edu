class AnnouncementsController < ApplicationController
  before_filter :login_required

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
  end

  def announce
    @announcement = Announcement.find(params[:id])
    @announcement.announce_to(params[:rule] || {})
    redirect_to @announcement
  end

end
