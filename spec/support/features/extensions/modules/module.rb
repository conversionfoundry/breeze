# Thanks Elabs.se 
# https://github.com/elabs/elabs_matchers/blob/master/lib/elabs_matchers/extensions/module.rb
Module.class_eval do
  def rspec(options={})
    RSpec.configure do |config|
      config.include self, options
    end
  end
end
