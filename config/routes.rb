Rails.application.routes.draw do
  resources :categories
  devise_for :admins
  
  get "/about", to: "home#about", as: "about"
  namespace :admin do
    resource :about, only: [:edit, :update], controller: "pages"
  end

  resources :products do
    resource :buy_now, only: [:show, :create], controller: :buy_now do
      get "success", on: :collection
    end
  end

  # Cart routes
  resources :carts, only: [:create, :show, :destroy] do
    member do
      patch :update_cart_item  # Updates quantity for a specific cart item
      get :checkout
      post :stripe_session
      post 'add_to_cart', to: 'carts#add_to_cart', as: :add_to_cart
      get :success
    end
  end
  resources :cart_items, only: [:create, :update, :destroy]

  resource :admin, only: [:show], controller: :admin
  
  # Health check and PWA files
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Root path
  root "home#index"
end
