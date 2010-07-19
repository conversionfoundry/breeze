class StaticFilesController < ActionController::Metal
  unloadable
  
  include ActionController::RackDelegation
  include ActionController::Streaming
  
  def serve
    if request.path =~ /^\/breeze\/([^\?\#]*$)$/
      Dir[File.join("#{Rails.root}", "vendor/plugins/*/public/#{$1}")].each do |filename|
        response.etag = [ filename, File.mtime(filename) ]
        if request.fresh? response
          response.status = 304
        else
          send_file filename, :type => Mime[File.extname(filename)[1..-1]], :disposition => "inline"
        end
        return
      end
    end
    
    response.status, response.content_type, response.body = 404, "text/plain", "not found"
  end
end