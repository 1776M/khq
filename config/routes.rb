Khq::Application.routes.draw do

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :groups
  resources :projects, :only => [:create, :destroy, :show]
  resources :basecases, :only => [:create, :destroy, :show] 
  resources :annuals do
       collection do
  		post :bulk_create
  	end
  end
  resources :borrowings
  resources :scenarios, :only => [:create, :destroy, :show] do
       collection do
  		get :filter
  	end
  end

  resources :actannuals
  resources :actborrowings
  resources :forwardcurves
  resources :swapcurves
  resources :epochfxrates
  resources :epochdates
  resources :currencies
  resources :actcurrencies
  resources :fxrates do
       collection do
  		get :filter
  	end
  end
  resources :rules
  resources :inputs
  resources :lookups
  resources :gains
  resources :dashboards
  resources :faces
  resources :senses
  resources :arbs

  root to: 'static_pages#home'

  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
  match '/environment', to: 'static_pages#environment'
  match '/uploadfile', to: 'static_pages#uploadfile'
  match '/uploadfiletwo', to: 'static_pages#uploadfiletwo'    
  match '/board', to: 'static_pages#board'    
  match '/exposure', to: 'static_pages#exposure'    

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
