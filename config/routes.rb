Yin11::Application.routes.draw do
  match "log_out" => "sessions#destroy"
  match "log_in" => "sessions#new"
  match "sign_up" => "users#new"

  get "profile/show"
  get "profile/edit"
  post "profile/update"

  resources :articles

  resources :reviews do
    resources :comments
    member do
      put "vote"
      get "new_comment"
      post "add_comment"
    end
  end

  resources :tips do
    collection do
      post "search"
    end
    member do
      put "vote"
    end
  end

  resources :badges

  resources :vendors

  resources :foods

  resources :products

  resources :cities, :only => [:index]

  resources :users
  resource :sessions, :only => [:new, :create, :destroy]

  #Wiki
  match "wiki" => "wiki#index"
  match "wiki/new" => "wiki#new"
  match "wiki/show" => "wiki#show"
  match "wiki/edit" => "wiki#edit"
  match "wiki/list" => "wiki#list"
  match "wiki/search" => "wiki#search"
  match "wiki/save" => "wiki#save"
  match "wiki/page_list" => "wiki#page_list"


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
