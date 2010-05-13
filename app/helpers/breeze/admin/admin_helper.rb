module Breeze::Admin::AdminHelper
  def flash_messages
    if flash.any?
      flash.to_a.map { |key, message|
        content_tag :div, (message + '<a href="#" class="close">&times;</a>').html_safe, :class => "flash #{key}"
      }.join.html_safe
    end
  end
end