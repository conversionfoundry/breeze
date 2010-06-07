Rails::Application.configure do
  config.load_paths += %w(middleware) unless config.load_paths.include? "middleware"

  config.middleware.insert_after ActionDispatch::Cookies, FlashSessionCookieMiddleware
end
