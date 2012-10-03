source "http://rubygems.org"
ruby "1.9.3"
# Declare your gem's dependencies in blorgh.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.
# jquery-rails is used by the dummy application
#gem "jquery-rail3"
#
#
group :development do 
  gem 'fuubar'
end

group :development, :test do
  gem 'fabricator'
  gem 'growl'
end

group :test do
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'capybara'
  gem 'rb-fsevent'
end

