require "set"

module Breeze
  module Content
    def self.classes(superclass = nil)
      returning (@classes || []).map(&:constantize) do |set|
        set.reject! { |k| !k.ancestors.include? superclass } unless superclass.nil?
        set << superclass if superclass.is_a?(Class)
      end
    end
    
    def self.register_class(*classes_to_register)
      @classes ||= Set.new(Item.subclasses)
      @classes.merge classes_to_register.map(&:to_s)
    end
    
    def self.[](permalink)
      Item.first :conditions => { :permalink => permalink }
    end
    
    def self.const_missing(sym)
      Custom::Type.get(sym) || super
    end
  end
end

require "breeze/content/custom/type"

Dir[File.expand_path("../../app/models/breeze/content/*.rb", File.dirname(__FILE__))].each do |f|
  require f
end
