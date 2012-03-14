Yin11::Application.routes.draw do
  match '/editor(/*requested_uri)' => 'mercury_auth#edit', :as => :mercury_editor
  Mercury::Engine.routes

  match '/home/gateway' => 'home#gateway'

  namespace :administrator do
    root :to => "base#index"

    resources :vendors
    resources :users, :except => [:new, :create, :destroy]
    resources :tags
    resources :products
    resources :pages
    resources :images
    resources :audits
    resources :recipes
    resources :invitations
    resources :awards
  end

  put 'administrator/base/toggle'
  put 'administrator/base/tune'

  match "me" => "personal#me"
  match "personal/favorites" => "personal#favorites"

  match "logout" => "sessions#destroy"
  match "login" => "sessions#new"
  match "sign_up" => "users#new"

  match "info_center" => "info_center#index"

  match "/images/uploads/*path" => "gridfs#serve"

  match "syncs/:type/new" => "syncs#new", :as => :sync_new
  match "syncs/:type/callback" => "syncs#callback", :as => :sync_callback
  #match "follow_yin11" => "syncs#follow_yin11"
  match '/more_desires/:mode/:page' => 'home#more_desires'
  match '/personal/more_feeds/:page' => 'personal#more_feeds'
  match '/desires/more/:tag/:page' => 'desires#more'
  match '/recipes/more/:tag/:page' => 'recipes#more'
  match '/products/more/:tag/:page' => 'products#more'

  resources :topics do
    member { post :mercury_update }
  end

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

  resources :tags  do
    collection do
      get "query"
    end
  end

  resources :relationships, :only => [:index, :show, :create] do
    collection do
      put "cancel"
    end
  end

  resources :reviews, :except => [:index] do
    collection do
      post :link
    end
  end

  resources :desires do
    member do
      put :admire
      post :solve
      post :vote
    end
    collection do
      #get :more
      get :afar
      get :feed
    end
  end

  resources :groups, :except => [:destroy] do
    member do
      put "join"
      put "quit"
    end
  end

  resources :votes do
    collection do
      put :like
    end
  end

  resources :awards do
    member do
      put :claim
    end
  end

  resources :images

  resources :vendors

  resources :places

  resources :intros do
    collection do
      get :collect
      get :score
    end
  end



  #resources :products, :except => [:new, :create]
  resources :products do
    collection do
      post :link
    end
  end

  resources :reports, :only => [:new, :create]

  match "masters" => "users#masters"

  resources :users, :except => [:destroy] do
    member do
      get "profile"
      put "block"
      put "unlock"
      get "activate"
      get 'verify_email'
      get "crop"
      put "crop_update"
    end
    collection do
      get 'validates_email'
      get 'validates_login_name'
      get "fans"
    end
  end

  resource :sessions, :only => [:new, :create, :destroy]

  resources :posts

  resources :pages do
    member { post :mercury_update }
  end

  resources :ingredients

  resources :steps

  resources :recipes do
    collection do
      #get :more
      get :browse
      post :seduce
    end
    member {post :mark}
  end

  resources :albums do
    member do
      put :collect
      put :remove
      put :pick_cover
    end
  end

  resources :notifications do
    member do
      put :read
    end
  end

  resources :messages

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
  #   namespace :administrator do
  #     # Directs /administrator/products/* to Administrator::ProductsController
  #     # (app/controllers/administrator/products_controller.rb)
  #     resources :products
  #   end

  root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
