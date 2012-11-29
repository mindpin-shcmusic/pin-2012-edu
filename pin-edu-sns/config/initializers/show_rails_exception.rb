require 'action_dispatch/middleware/show_exceptions'

module ActionDispatch
  class ShowExceptions
    private
      def render_exception_with_template(env, exception)
        env[:exception] = exception

        body = ErrorsController.action(:show).call(env)
        log_error(exception)
        body
      rescue Exception => ex
        p ex.message
        render_exception_without_template(env, exception)
      end
      
      alias_method_chain :render_exception, :template
  end
end