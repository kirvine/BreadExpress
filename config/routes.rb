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
