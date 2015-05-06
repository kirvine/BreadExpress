BreadExpress::Application.routes.draw do
  # Routes for main resources
  resources :users
  resources :customers
  resources :addresses
  resources :orders
  resources :order_items
  resources :items
  resources :item_prices
  resources :sessions

  # routes related carts and checking out
  post 'add_item/:id' => 'items#add_item', :as => :add_item
  get 'remove_item/:id' => 'items#remove_item', :as => :remove_item
  get 'cart' => 'orders#cart', :as => :cart
  get 'empty_cart' => 'orders#empty_cart', :as => :empty_cart
  get 'checkout' => 'orders#checkout', :as => :checkout

  # baking route
  get 'baking_list' => 'orders#baking_list', :as => :baking_list

  # shipping route
  get 'shipping_list' => 'orders#shipping_list', :as => :shipping_list

  # admin dashboard
  get 'dashboard' => 'users#dashboard', as: :dashboard
  
  # Authentication routes
  get 'user/edit' => 'users#edit', as: :edit_current_user
  get 'signup' => 'users#new', as: :signup
  get 'logout' => 'sessions#destroy', as: :logout
  get 'login' => 'sessions#new', as: :login

  # Semi-static page routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search

  # You can have the root of your site routed with 'root'
  root 'home#index'
end
