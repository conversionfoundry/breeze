Rails.application.routes.draw do |map|
  devise_for :admin, :class_name => "Breeze::Admin::User"

  scope "admin", :name_prefix => "admin", :module => "breeze/admin" do
    resources :users
    root :to => "dashboards#show"
  end
  
  root :to => "breeze/contents#show"
  match "*path" => "breeze/contents#show"
end