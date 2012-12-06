module TabFilter
  def filter(default, &block)
    Filter.new(default, self, &block)._current_collection
  end

  class Filter
    def initialize(default, context, &block)
      @default = default
      @context = context
      @tabs    = {}
      self.instance_eval(&block)
    end

    def method_missing(name, *_, &block)
      @tabs[name] = block
    end

    def _current_collection
      tab = _get_collection

      result = case tab
               when nil, :default
                 @default
               else
                 tab
               end

      @context.instance_eval {sort_scope(result).paginated(params[:page])}
    end

  private

    def _tab_name
      @context.params[:tab] && @context.params[:tab].to_sym
    end

    def _get_collection
      block = @tabs[_tab_name]
      @context.instance_eval &block if block
    end

  end
end
