Rails.application.routes.draw do
  get "profiles/show"
  get "orders/index"
  get "orders/show"
  resources :categories
  resource :profile, only: [:show]
  devise_for :admins
  
  devise_for :users
  
  get "/about", to: "home#about", as: "about"
  namespace :admin do
    get "orders/index"
    get "orders/show"
    resource :about, only: [:edit, :update], controller: "pages"
  end

  resources :orders, only: [:show] do
  collection do
    get :past_orders 
  end
end

  resources :products do
    resource :buy_now, only: [:show, :create], controller: :buy_now do
      get "success", on: :collection
    end
  end

  resources :cart_items, only: [:update]

  resources :carts, only: [:create, :show, :destroy] do
     patch 'update_cart_item/:id', on: :member, to: 'carts#update_cart_item', as: 'update_cart_item'
    get "checkout", on: :member, to: "carts#checkout"
    post "stripe_session", on: :member, to: "carts#stripe_session"
    get "success", on: :member, to: "carts#success"
  end

  resource :admin, only: [:show], controller: :admin
  
  # Health check and PWA files
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Root path
  root "home#index"
end
