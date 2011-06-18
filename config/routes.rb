Yin11::Application.routes.draw do
  resources :criticisms

  resources :recommendations

  match "log_out" => "sessions#destroy"
  match "log_in" => "sessions#new"
  match "sign_up" => "users#new"

  match "/images/uploads/*path" => "gridfs#serve"

  get "profile/show"
  get "profile/edit"
  post "profile/update"
  get "profile/edit_current_city"
  post "profile/update_current_city"

  get "home/reviews"
  post "home/watch_foods"
  put "home/vote"
  get "home/new_comment"
  post "home/add_comment"
  put "home/toggle_disabled"

  resources :articles do
    resources :comments
  end

  resources :recommendations do
    resources :comments
  end

  resources :reviews do
    resources :images
    resources :comments
  end

  resources :tips do
    collection do
      post "search"
    end
  end

  resources :badges

  resources :vendors do
    collection do
      post "search"
    end
  end

  resources :foods do
    member do
      put "watch"
    end
  end

  resources :products

  resources :cities, :only => [:index]

  resources :users
  resource :sessions, :only => [:new, :create, :destroy]

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
