module Breeze
  module Admin
    module AdminHelper
      unloadable
      
      def flash_messages
        if flash.any?
          flash.to_a.map { |key, message|
            content_tag :div, (message + '<a href="#" class="close">&times;</a>').html_safe, :class => "flash #{key}"
          }.join.html_safe
        end
      end
  
      def edit_form_for(form, klass = nil, locals = {})
        klass ||= form.object.class

        possible_templates = klass.self_and_superclasses.map { |c| File.join("breeze", "admin", "contents", "forms", c.to_s.underscore.tr('/', '.').sub(/^breeze.content./, "")) }

        possible_templates.each do |template_path|
          begin
            return render(:partial => template_path, :locals => locals.merge(:form => form))
          rescue ActionView::MissingTemplate
            next
          end
        end
        
        if form.object.is_a? Breeze::Content::Custom::Instance 
          form.object.edit_form(form)
        else
          content_tag :p, "There is no configuration for this content type."
        end
      end
      
      def admin_menu
        # TODO: customisable menu
        menu = []
        menu << { :name => "Dashboard", :path => admin_root_path, :regexp => /^\/admin\/$/ }
        menu << { :name => "Pages",     :path => admin_pages_path  } if can? :manage, Breeze::Content::Item
        menu << { :name => "Assets",    :path => admin_assets_path } if can? :manage, Breeze::Content::Item
        menu << { :name => "Users",     :path => admin_users_path  } if current_user.admin?
        menu << { :name => "Themes",    :path => admin_themes_path } if can? :manage, Breeze::Theming::Theme
        menu << { :name => "Custom types",  :path => admin_custom_types_path } if can? :manage, Breeze::Content::Custom::Type
        
        ordering = current_user.menu_order || []
        menu = menu.sort_by { |item| ordering.index(item[:name]) || 999999 }
        
        items = menu.collect do |item|
          content_tag :li, link_to(item[:name], item[:path]), :class => "#{:active if (item[:regexp] || /^#{item[:path]}/) === request.path}"
        end.join.html_safe
        
        content_tag :ul, items, :class => "menu"
      end
    
      [:form_for, :fields_for].each do |meth|
        src = <<-END_SRC
          def breeze_#{meth}(record_or_name_or_array, *args, &proc)
            options = args.extract_options!
            options[:builder] ||= Breeze::Admin::FormBuilder
            options[:html] ||= {}
        
            class_names = options[:html][:class] ? options[:html][:class].split(" ") : []
            class_names << "breeze-form"
            if options[:as]
              class_names << options[:as]
            else 
              class_names << case record_or_name_or_array
                when String, Symbol then record_or_name_or_array.to_s               # :post => "post"
                when Array then record_or_name_or_array.last.class.to_s.underscore  # [@post, @comment] # => "comment"
                else record_or_name_or_array.class.to_s.underscore                  # @post => "post"
              end
            end
            options[:html][:class] = class_names.join(" ")
        
            #{meth}(record_or_name_or_array, *(args << options), &proc)
          end
        END_SRC
        module_eval src, __FILE__, __LINE__
      end
    end
  end
end