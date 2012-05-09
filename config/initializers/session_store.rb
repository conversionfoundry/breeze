Rails.application.class.configure do
  config.autoload_paths += %W(#{config.root}/vendor/engines/breeze/app/middleware) unless config.autoload_paths.include? "middleware"

  config.middleware.insert_after ActionDispatch::Cookies, FlashSessionCookieMiddleware
end
