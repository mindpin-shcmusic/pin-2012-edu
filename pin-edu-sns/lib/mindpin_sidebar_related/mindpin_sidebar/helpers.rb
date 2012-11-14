module MindpinSidebar
  module Helpers
    def mindpin_sidebar(rule)
      MindpinSidebar::Base.render_navs(self, rule)
    end
  end
end