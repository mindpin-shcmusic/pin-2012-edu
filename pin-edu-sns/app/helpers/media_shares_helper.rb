module MediaSharesHelper
  def do_clear_media_share_tip_message!
    if logged_in?
      current_user.media_share_tip_message.clear
      current_user.media_share_tip_message.send_count_to_juggernaut
    end
  end

  def shared_time(user, media_resource)
    media_resource = media_resource.toppest_resource(media_resource)
    media_share = MediaShare.where(:receiver_id => user.id, :media_resource_id => media_resource.id).first
    media_share.created_at
  end
end
