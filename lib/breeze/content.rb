require "set"

module Breeze
  module Content
    def self.classes(superclass = nil)
      returning (@classes || []).map(&:to_s).map(&:constantize) do |set|
        set.reject! { |k| !k.ancestors.map(&:to_s).include? superclass.to_s } unless superclass.nil?
        set << superclass if superclass.is_a?(Class)
      end.uniq
    end
    
    def self.register_class(*classes_to_register)
      @classes ||= Set.new(Item.subclasses)
      @classes.merge classes_to_register.map(&:to_s)
    end
    
    def self.unregister_class(*classes_to_unregister)
      classes_to_unregister.each { |c| @classes.delete c.to_s }
    end
    
    def self.[](permalink)
      Breeze.run_hook(:get_content_by_permalink, permalink) ||
      Item.first(:conditions => { :permalink => permalink })
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
