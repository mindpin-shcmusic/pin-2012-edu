class ApplicationController < ActionController::Base
  protect_from_forgery

  def path_for(path)
    route_base_scope = '/management'
    File.join(route_base_scope, path)
  end
end
