class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include ApplicationMethods
  helper :all

protected

  def sort_params_to_scope
    dir   = ['asc', 'desc'].include?(params[:dir].to_s) ? params[:dir] : nil
    scope = params[:sort] ? "by_#{params[:sort]}" : nil
    [scope, dir].compact
  end

  def sort_scope(resource)
    return resource if sort_params_to_scope.blank?
    resource.send(*sort_params_to_scope)
  rescue NoMethodError
    redirect_to :action => :index
    resource
  end

end
