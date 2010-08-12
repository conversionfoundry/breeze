Rails.application.routes.draw do
  devise_for :admin, :class_name => "Breeze::Admin::User"

  scope "admin", :name_prefix => "admin", :module => "breeze/admin" do
    resources :pages do
      member do
        put :move
        put :sort
        post :duplicate
      end
      collection do
        get :list
      end
    end
    
    resources :contents do
      member do
        post :duplicate
        post :insert
        get  :instances
      end
      collection do
        put  :reorder
        get  :search
      end
    end
    
    resources :custom_types do
      collection do
        get :new_field
      end
    end

    get "assets/folders" => "assets/folders#show"
    post "assets/folders" => "assets/folders#create"
    
    resources :assets
    
    namespace :assets do
      resources :folders
    end
    get "assets/folders/*path" => "assets/folders#show"
    
    match "themes/:theme_id/raw/*id" => "themes/files#show", :as => :raw_admin_theme_file
    match "themes/:theme_id/files/*id" => "themes/files#edit", :as => :edit_admin_theme_file
    match "themes/:theme_id/folders/*id" => "themes/folders#edit", :as => :edit_admin_theme_folder
    resources :themes do
      scope :module => "themes" do
        resources :files
        resources :folders
      end
      member do
        put :enable
        put :disable
      end
      collection do
        put :reorder
      end
    end
    resources :users do
      member do
        put :preferences
      end
    end
    
    namespace :activity do
      resources :log_messages
    end
    
    resource :settings do
      member do
        get :current_time
      end
    end
    
    root :to => "dashboards#show"
  end
  
  match "stylesheets/*path", :to => "breeze/stylesheets#show"
  root :to => "breeze/contents#show"
  match "breeze/*path", :to => "static_files#serve"
  match "*path" => "breeze/contents#show"
end