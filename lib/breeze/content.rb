module Breeze
  module Content
    def self.[](permalink)
      Item.first :conditions => { :permalink => permalink }
    end
  end
end