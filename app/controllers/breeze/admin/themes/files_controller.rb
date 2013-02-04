module Breeze
  module Admin
    module Themes
      class FilesController < Breeze::Admin::AdminController
        def index
          @files = theme.files.sort
        end
        
        def show
          @path = "/" + Array(params[:id]).join("/").gsub("+", " ")
          file_path = theme.file(@path)
          send_file file_path, :type => Mime[File.extname(file_path)[1..-1]].to_s, :disposition => "inline"
        end
        
        def edit
          @path = "/" + Array(params[:id]).join("/").gsub("+", " ")
          if request.put?
            @contents = (params[:file] ? params[:file][:contents] : nil) || ""
            write_file(theme.path + @path, @contents)

            if params[:file] && params[:file][:name]
              @old_path = @path
              @path = File.join File.dirname(@old_path), params[:file][:name]
              FileUtils.mv theme.file(@old_path), theme.file(@path)
              render :action => :move
            end

          elsif request.delete?
            FileUtils.rm_r theme.file(@path)
            render :action => :destroy
          else
            @contents = File.read(theme.file(@path))
          end

          @editing_help_type = editing_help_type(@path)
          @editing_help = editing_help(@editing_help_type)
        end


      protected

        def theme
          @theme ||= Breeze::Theming::Theme[params[:theme_id]]
        end

        helper_method :theme

        def editing_help_type(path)
          filename = path.split('/').last
          if filename.ends_with?('.html.erb')
            if filename.starts_with?('_')
              return 'Partial'
            else
              return 'Layout'
            end
          end
        end

        # TODO: Store editing help with the theme, so it can be customised for each site.
        # TODO: List tags for custom types
        def editing_help(editing_help_type)
          case editing_help_type
          when 'Partial'
            help =  '<h4>Useful tags</h4>'
            help << '<p><code><%= navigation %></code><br />'
            help << '<code><%= page.page_title %><c/ode><br />' 
            help << '<code><%= stylesheet_link_tag "stylename" %></code><br />' 
            help << '<code><%= javascript_include_tag "scriptname" %></code><br />' 
            help << '<code><%= region :example %></code></p>' 
            # help << '<h4>Tags for this Custom Type</h4>'
          when 'Layout' 
            help =  '<h4>Useful tags</h4>'
            help << '<p><code><%= navigation %></code><br />'
            help << '<code><%= page.page_title %><c/ode><br />' 
            help << '<code><%= stylesheet_link_tag "stylename" %></code><br />' 
            help << '<code><%= javascript_include_tag "scriptname" %></code><br />' 
            help << '<code><%= region :example %></code></p>' 
          end
        end


      end
    end
  end
end
