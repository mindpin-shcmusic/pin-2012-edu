class NotificationsController < ApplicationController
  def index
    @notifications = Notification.for_user(current_user).paginate(:page => params[:page], :per_page => 20)
  end

  def read
    @notification = Notification.find params[:id]
    @notification.read!

    render :status => 200,
           :text   => 'Oh Yeah!'
  end

  def destroy
    @notification = Notification.find params[:id]
    @notification.destroy

    render :status => 200,
           :text   => 'Oh Yeah'
  end

  def read_all
    Notification.read_all!(current_user)

    render :status => 200,
           :text   => 'Oh Yeah!'
  end
end
