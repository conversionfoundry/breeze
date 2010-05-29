require 'rack/utils'

class FlashSessionCookieMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['HTTP_USER_AGENT'] =~ /^(Adobe|Shockwave) Flash/
      req = Rack::Request.new(env)
      session_key = Rails::Application.config.session_options[:key]
      unless req.params[session_key].nil?
        env['HTTP_COOKIE'] = "#{session_key}=#{req.params[session_key]}".freeze
      end
    end
    
    @app.call(env)
  end
end