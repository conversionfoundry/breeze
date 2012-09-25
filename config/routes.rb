Breeze::Engine.routes.draw do
  devise_for :admin, :class_name => "Breeze::Admin::User", :module => :devise

  namespace :admin, :as => "admin", :module => "admin" do
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
        get  :live
      end
      collection do
        put  :reorder
        get  :search
        get  :add
      end
    end
    
    resources :custom_types do
      collection do
        get :new_field
      end
    end

    get "assets/images(.:format)" => "assets#images"

    
    resources :assets
    
    namespace :assets do
      resources :folders
    end
    get "assets/folders" => "assets/folders#show"
    post "assets/folders" => "assets/folders#create"
    get "assets/folders/*path" => "assets/folders#show"
    
    match "themes/:theme_id/raw/*id" => "themes/files#show", :as => :raw_admin_theme_file
    match "themes/:theme_id/files/*id" => "themes/files#edit", :as => :edit_admin_theme_file, :format => false
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
    
    resources :redirects
    
    root :to => "dashboards#show"
  end
  
  # match "stylesheets/*path", :to => "stylesheets#show", :format => false
  root :to => "contents#show"
  #match "breeze/*path", :to => "static_files#serve"
  match "*path" => "contents#show", :format => false
end
