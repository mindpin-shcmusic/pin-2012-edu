class AnnouncementsController < ApplicationController
  before_filter :login_required
  before_filter :not_for_students, :only => [:new, :create, :announce, :mine]

  def new
    @announcement = current_user.created_announcements.build
  end

  def index
    @announcements = filter current_user.received_announcements do
      received {:default}
      unread   {current_user.unread_announcements}
      mine     {current_user.created_announcements}
    end
  end

  def create
    create_resource current_user.created_announcements.build params[:announcement] do |announcement|
      courses = (params[:course_ids]||'').split(',')
      announcement.announce_to(:courses => courses)
    end

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
