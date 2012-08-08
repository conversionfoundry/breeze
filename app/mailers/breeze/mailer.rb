module Breeze
  class Mailer < ActionMailer::Base
  #   class Premailer < ::Premailer
  #     def initialize(string, options = {})
  #       @options = {:warn_level => Warnings::SAFE, 
  #                   :line_length => 65, 
  #                   :link_query_string => nil, 
  #                   :base_url => nil,
  #                   :remove_classes => false}.merge(options)

  #       @html_file = options[:base_url]
  #       @is_local_file = false

  #       @css_warnings = []

  #       @css_parser = CssParser::Parser.new({:absolute_paths => true,
  #                                            :import => true,
  #                                            :io_exceptions => false
  #                                           })

  #       @doc, @html_charset = Nokogiri::HTML(string)
  #       @processed_doc = convert_inline_links(@doc, @html_file)
  #       load_css_from_html!
  #     end

  #     def self.inline_css(html, options = {})
  #       new(html, options)#.to_inline_css
  #     end
  #   end

  # protected
  #   def collect_responses_and_parts_order(headers)
  #     responses, parts_order = super
  #     responses.each do |response|
  #       if response[:content_type] == "text/html"
  #         response[:body] = inline_css response[:body]
  #       end
  #     end
  #     [ responses, parts_order ]
  #   end

  #   def inline_css(html)
  #     Premailer.inline_css html, :base_url => "http://#{Rails.application.config.action_mailer.default_url_options[:host]}/"

  #   end
  end
end
