module MindpinSidebar
  class ControllerItem
    attr_accessor :controller_name, :options
    def initialize(controller_name, options)
      self.controller_name = controller_name
      self.options = options
    end

    def is_current?(controller, action)
      self.controller_name == controller && (
        options.blank? || ( [options[:only]].flatten.include?(action) ) || ( ![options[:except]].include?(action) )
      )
    end
  end
end