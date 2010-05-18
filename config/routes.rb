Rails.application.routes.draw do |map|
  devise_for :admin, :class_name => "Breeze::Admin::User"

  scope "admin", :name_prefix => "admin", :module => "breeze/admin" do
    resources :pages
    
    match "themes/:theme_id/raw/*id" => "themes/files#show", :as => :raw_admin_theme_file
    match "themes/:theme_id/files/*id" => "themes/files#edit", :as => :edit_admin_theme_file
    match "themes/:theme_id/folders/*id" => "themes/folders#edit", :as => :edit_admin_theme_folder
    resources :themes do
      scope :module => "themes" do
        resources :files
      end
      member do
        put :enable
        put :disable
      end
      collection do
        put :reorder
      end
    end
    resources :users
    root :to => "dashboards#show"
  end
  
  match "stylesheets/*path", :to => "breeze/stylesheets#show"
  root :to => "breeze/contents#show"
  match "*path" => "breeze/contents#show"
end