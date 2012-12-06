module CreateHelper
  def create_resource(resource, options={}, &block)
    Creator.new(resource, options, block, self).request
  end

  def create_resource_ajax(resource, options={}, &block)
    Creator.new(resource, options, block, self).ajax_request
  end

  class Creator
    def initialize(resource, options, block, context)
      options.assert_valid_keys :error_url, :success_url, :partial
      
      @resource      = resource
      
      @success_url   = options[:success_url]
      @error_url     = options[:error_url]
      @partial       = options[:partial]
      @error_message = options[:error_message]

      @block         = block
      @context       = context
    end

    def request
      if @resource.save
        @block && @block.call(@resource)
        return @context.redirect_to(@success_url || {:action => :show, :id => @resource.id})
      end

      @context.flash_error(@error_message && @resource)
      @context.redirect_to(@error_url || {:action => :new})
    end

    def ajax_request
      if @resource.save
        @block && @block.call(@resource)
        return @context.render :partial => @partial, 
                               :locals => {:models => [@resource]}
      end

      @context.render :status => 422, 
                      :text => 'blahblah'
    end
  end

end
