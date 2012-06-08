module ApplicationHelper

  def path_for(path)
    route_base_scope = '/management'
    File.join(route_base_scope, path)
  end

end
