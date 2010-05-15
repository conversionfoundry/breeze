module Breeze
  module Content
    def self.[](permalink)
      Item.first :conditions => { :permalink => permalink }
    end
  end
end

Dir[File.expand_path("../../app/models/breeze/content/*.rb", File.dirname(__FILE__))].each do |f|
  require f
end
