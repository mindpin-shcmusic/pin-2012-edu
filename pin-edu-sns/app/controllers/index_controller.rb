class IndexController < ApplicationController
  before_filter :login_required
  
  def index
    if current_user.is_admin?
      return redirect_to "/admin"
    end
    redirect_to '/file'
  end

  def user_complete_search
    # user_ids = User.complete_search(params[:q]).map { |doc|
    #   doc['id']
    # }[0...10]

    # @users = user_ids.map{ |user_id|
    #   User.find_by_id(user_id)
    # }.compact.uniq
    @users = User.all

    render :partial => 'complete_search/user'
  end
  
end
