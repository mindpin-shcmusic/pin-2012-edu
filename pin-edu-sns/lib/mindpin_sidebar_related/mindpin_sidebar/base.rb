module MindpinSidebar
  class Base
    def self.config(&block)
      @@config = {}
      self.instance_eval(&block)
    end

    def self.render_navs(view, rule)
      html = "<div class='page-navbar'>"
      
      @@config[rule].each do |nav|
        html << render_nav(view,nav)
      end

      html << "</div>"

      view.raw(html)
    end

    def self.render_nav(view, nav)
      klass = nav.is_current?(view) ? "item current" : "item"
      nav_html = "<div class='#{klass}'>"
      nav_html << "<a href='#{nav.options[:url]}'>#{options[:name]}</a>"
      nav_html << render_subnavs(view, nav)
      nav_html << "</div>"

      nav_html
    end

    def self.render_subnavs(view, nav)
      return "" if nav.subnavs.blank?

      nav_html = "<div class='subitems'>"
      nav.subnavs.each do |subnav|
        klass = subnav.is_current?(view) ? "subitem current" : "subitem"
        nav_html << "<div class='#{klass}'>"
        nav_html << "<a href='#{subnav.options[:url]}'>#{subnav.options[:name]}</a>"
        nav_html << "</div>"
      end
      nav_html << "</div>"

      nav_html
    end

    ######## config DSL #########
    def self.rule(rules, &block)
      MindpinSidebar::CurrentContext.instance.rules = [rules].flatten
      self.instance_eval(&block)
      MindpinSidebar::CurrentContext.instance.rules = nil
    end

    def self.nav(title, options, &block)
      nav = MindpinSidebar::Nav.new(title, options)
      MindpinSidebar::CurrentContext.instance.nav = nav

      self.instance_eval(&block)

      MindpinSidebar::CurrentContext.instance.rules.each do |rule|
        @@config[rule] ||= []
        @@config[rule] << nav
      end

      MindpinSidebar::CurrentContext.instance.nav = nil
    end

    def self.subnav(title, options, &block)
      nav = MindpinSidebar::Nav.new(title, options)
      MindpinSidebar::CurrentContext.instance.subnav = nav

      self.instance_eval(&block)

      MindpinSidebar::CurrentContext.instance.nav.subnavs << nav

      MindpinSidebar::CurrentContext.instance.subnav = nil
    end

    def self.controller(controller_name, options = {})
      item = MindpinSidebar::ControllerItem.new(controller_name, options)
      context = MindpinSidebar::CurrentContext.instance
      nav = context.subnav || context.nav
      nav.controller_items << item
    end
    ######## config DSL #########
  end
end