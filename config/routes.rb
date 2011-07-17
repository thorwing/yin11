Yin11::Application.routes.draw do
  put "admin/base/toggle_disabled"

  namespace :admin do
    root :to => "base#index"

    resources :articles
    resources :badges
    resources :vendors
    resources :reviews, :only => [:index, :show, :destroy]
    resources :users, :except => [:new, :create]
    resources :tips, :only => [:index, :show, :destroy]
  end

  match "log_out" => "sessions#destroy"
  match "log_in" => "sessions#new"
  match "sign_up" => "users#new"

  match "/images/uploads/*path" => "gridfs#serve"

  get "locations/search"
  get "locations/edit_current_city"
  post "locations/update_current_city"
  get "locations/show_nearby_items"

  get "profile/new_watched_location"
  post "profile/create_watched_location"
  put "profile/delete_watched_location"
  get "profile/show"
  get "profile/edit"
  post "profile/update"

  get "home/more_items"
  get "home/items"
  get "home/regions"
  get "home/cities"
  post "home/watch_foods"
  put "home/vote"

  resources :comments

  resources :password_resets

  resources :tags, :only => [:index]

  resources :articles, :only => [:index, :show] do
    resources :comments
  end

  resources :recommendations, :except => [:destroy] do
    resources :comments
  end

  resources :reviews, :except => [:destroy] do
    collection do
      get "choose_mode"
    end
    resources :comments
  end

  resources :groups, :except => [:destroy] do
    member do
      put "join"
      put "quit"
      put "block"
      put "unlock"
    end
  end

  resources :images, :only => [:create]

  resources :tips, :except => [:destroy] do
    collection do
      post 'search'
    end
    member do
      put 'collect'
      get 'revisions'
      put 'roll_back'
    end
  end

  resources :badges, :only => [:index, :show]

  resources :vendors, :except => [:edit, :update, :destroy] do
    collection do
      post "search"
    end
  end

  resources :reports, :only => [:new, :create]

  resources :products

  resources :cities, :only => [:index]

  resources :users, :only => [:new, :create]
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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
