$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "breeze/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "breeze"
  s.version     = Breeze::VERSION
  s.authors     = ["Matt Powell, Blair Neate, Isaac Freeman"]
  s.email       = ["isaac@leftclick.com"]
  s.homepage    = ""
  s.summary     = "Breeze is a Content Management System."
  s.description = "Breeze is a Content Management System."

  # Manifest
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  # s.files = Dir["{app,config,db,lib}/**/*"] #+ ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  # s.test_files = Dir["test/**/*"]

  # Dependencies
  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_dependency "rails", "~> 3.2.3"
  # s.add_dependency "jquery-rails"

  #s.add_development_dependency "sqlite3"
end

