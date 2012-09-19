require "set"

module Breeze
  module Content
    def self.classes(superclass = nil)
      (@classes || []).map(&:to_s).map(&:constantize).tap do |set|
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
      # Allow plugins to provide content
      content = Breeze.run_hook(:get_content_by_permalink, permalink)
      # Otherwise, look for page in Breeze Core
      content = Item.where(permalink: permalink).first if content.blank? || content.is_a?(String)
      content
    end
    
    def self.const_missing(sym)
      #Custom::Type.get(sym) || super
    end
  end
end
