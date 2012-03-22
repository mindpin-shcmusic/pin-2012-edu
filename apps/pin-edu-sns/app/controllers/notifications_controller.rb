class NotificationsController < ApplicationController
  respond_to :html, :js
  
  def index
    @notifications = Notification.all
  end

  def create
    Notification.create(
      :user_id => current_user.id,
      :kind => 'be_answered',
      :data => Notification.count + 1
    )
    @notifications = Notification.all
  end
  
  def show
    @notification = Notification.find(params[:id])
    @notification.set_readed
    
    return redirect_to :back
  end
  
  def destroy
    notification = Notification.find(params[:id])
    notification.destroy
    
    return redirect_to :back
  end

end
