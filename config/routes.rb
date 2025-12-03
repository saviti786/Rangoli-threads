Rails.application.routes.draw do
  # get "pages/show"

  # Public pages
  get "/pages/:slug", to: "pages#show", as: "page"

  # Convenience routes for about and contact
  get "/about", to: "pages#show", slug: "about", as: "about"
  get "/contact", to: "pages#show", slug: "contact", as: "contact"

  # Products routes
  resources :products, only: [ :index, :show ] do
    collection do
      get :search
      get :on_sale
      get :new_arrivals
      get :recently_updated
    end
  end

  # Cart routes
  get "cart", to: "cart#show"
  post "cart/add/:id", to: "cart#add", as: "add_to_cart"
  patch "cart/update/:id", to: "cart#update", as: "update_cart_item"
  delete "cart/remove/:id", to: "cart#remove", as: "remove_from_cart"
  delete "cart/clear", to: "cart#clear", as: "clear_cart"

  # Checkout routes
  get "checkout", to: "checkout#new", as: "new_checkout"
  post "checkout", to: "checkout#create", as: "checkout"

  # Orders routes
  resources :orders, only: [ :index, :show ]

  # Categories
  resources :categories, only: [ :show ]

  namespace :admin do
    resources :pages, only: [ :edit, :update ]
    # get "pages/edit"
    # get "pages/update"
    root to: "dashboard#index"
    resources :products
    resources :categories
    get "dashboard/index"
  end
  devise_for :users, skip: [ :passwords ]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root "home#index"
  # root "products#index"
end
