module Breeze
  module Admin
    module Activity
      class ObjectReference
        include Mongoid::Document
        
        field :class_name
        field :oid
        field :str
        
        def live?
          !object.nil?
        end
        
        def object
          @object ||= klass.where(:_id => oid).first
        end
        
        def klass
          class_name.to_s.constantize
        end
        
        def base_class
          klass.base_class
        end
        
        def to_s; self.str ||= object.to_s; end
        
        def linked
          if live?
            link = object.respond_to?(:permalink) ? object.permalink : "/admin/#{base_class.name.demodulize.pluralize.underscore}/#{oid}"
            %Q{<a href="#{link}">#{to_s}</a>}
          else
            %Q{<del>#{to_s}</del>}
          end
        end
      end
    end
  end
end