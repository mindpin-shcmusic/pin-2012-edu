module TabFilter
  def filter(default, tabs)
    Filter.new(default, tabs, self).current_collection
  end

  class Filter
    def initialize(default, tabs, context)
      @default = default
      @container = tabs
      @context = context
    end

    def current_collection
      tab = @container[@context.params[:tab].to_sym]

      result = case tab
               when nil, :default
                 @default
               else
                 tab
               end

      @context.send(:sort_scope, result).paginated(@context.params[:page])
    end

  end

end
