Yin11::Application.routes.draw do

  namespace :admin do
    root :to => "base#index"

    resources :articles
    resources :badges
    resources :vendors
    resources :reviews, :only => [:index, :show, :destroy]
    resources :users, :except => [:new, :create]
    resources :tips, :only => [:index, :show, :destroy]
    resources :tags
  end

  put 'admin/base/toggle'

  match "logout" => "sessions#destroy"
  match "login" => "sessions#new"
  match "sign_up" => "users#new"

  match "/images/uploads/*path" => "gridfs#serve"

  match "syncs/:type/new" => "syncs#new", :as => :sync_new
  match "syncs/:type/callback" => "syncs#callback", :as => :sync_callback
  match "follow_yin11" => "syncs#follow_yin11"

  get "home/more_items"

  resources :search do
    collection do
      get "tag"
      get "region"
    end
  end

  resources :comments do
    member do
      put "toggle"
    end
  end

  resources :password_resets

  resources :tags, :only => [:index]

  resources :articles, :only => [:index, :show]

  resources :relationships, :only => [:index, :show, :create] do
    collection do
      put "cancel"
    end
  end

  resources :locations do
    collection do
      get "search"
      get "edit_current_city"
      post "update_current_city"
      get "show_nearby_items"
      get "regions"
      get "cities"
    end
  end

  resources :profile do
    collection do
      get "new_watched_location"
      post "create_watched_location"
      put "delete_watched_location"
      put "delete_watched_tag"
      post "watch_tags"
      put "toggle"
      get "custom"
    end
  end

  resources :reviews, :except => [:destroy] do
    collection do
      get "choose_mode"
    end
  end

  resources :groups, :except => [:destroy] do
    member do
      put "join"
      put "quit"
    end
  end

  resources :votes, :only => [:create]

  resources :images, :only => [:create]

  resources :tips, :except => [:destroy] do
    member do
      put 'collect'
      get 'revisions'
      put 'roll_back'
    end
  end

  resources :badges, :only => [:index, :show]

  resources :vendors, :except => [:edit, :update, :destroy] do
    collection do
      get "mine"
      get 'browse'
    end
    member do
      put 'pick'
    end
  end

  resources :reports, :only => [:new, :create]

  resources :users, :except => [:index, :destroy] do
    member do
      put "block"
      put "unlock"
      get "activate"
    end
    collection do
      get 'check_email'
    end
  end

  resource :sessions, :only => [:new, :create, :destroy]

  resources :posts

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
