# cookie_verification_secret
Rails.application.config.secret_token = 'bbd4cd952a4dc5a511f7eed224b7a5dc71ef9b5e873868cdd6f721fa4409a61304ac718e618fc6d912dcdefb342279f2542291e9ddd369ba3366ad4c11602880'

# session
case Rails.env
  when 'production'
    Rails.application.config.session_store :cookie_store, {
      :domain => 'yinyue.edu',
      :key    => '_mindpin_edu_session'
    }
  when 'development'
    Rails.application.config.session_store :cookie_store, {
      :domain => 'yinyue.edu',
      :key    => '_mindpin_edu_session_devel'
    }
end

# flash_cookie_session_fix
# 放在这里以保证config能取到值，否则由于加载顺序问题，取值可能为nil

class FlashCookieSessionMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['HTTP_USER_AGENT'] =~ /^(Adobe|Shockwave) Flash/
      req = Rack::Request.new(env)

      session_key   = Rails.application.config.session_options[:key]
      session_value = req.params[session_key]
      
      Rails.logger.debug("flash cookie session key   : #{session_key}")
      Rails.logger.debug("flash cookie session value : #{session_value}")
      
      http_accept   = req.params['_http_accept']

      env['HTTP_COOKIE'] = [session_key, session_value].join('=').freeze if !session_value.blank?
      env['HTTP_ACCEPT'] = http_accept.freeze if !http_accept.blank?
    end
    @app.call(env)
  end
end

Rails.application.middleware.insert_before(
  Rails.application.config.session_store,
  FlashCookieSessionMiddleware
)