$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "breeze/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "breeze"
  s.version     = Breeze::VERSION
  s.authors     = ["Matt Powell", "Blair Neate", "Isaac Freeman", "Alban Diguer"]
  s.email       = ["isaac@leftclick.com", "alban@leftclick.com"]
  s.homepage    = ""
  s.summary     = "Breeze is a Content Management System."
  s.description = "Breeze is a Content Management System."

  s.files         = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"] 
  s.require_paths = ['lib']
  s.requirements << 'none'
  s.required_ruby_version = '>= 1.9.0'
  s.required_rubygems_version = '>= 1.3.6'

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "pry-rails"
  
  s.add_dependency "rails", "~> 3.2.0"
  s.add_dependency "mongoid", "~> 3.0.5"
  s.add_dependency "carrierwave", "~> 0.6.2"
  s.add_dependency "carrierwave-mongoid", "~> 0.1.0"
  s.add_dependency "cancan", "~> 1.6.8"
  s.add_dependency "devise", "~> 2.0.4"
  s.add_dependency "rmagick", "~> 2.13.1"
end

