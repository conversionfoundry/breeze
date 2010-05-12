Rails.application.routes.draw do |map|
  root :to => "breeze/contents#show"
  match "*path" => "breeze/contents#show"
end