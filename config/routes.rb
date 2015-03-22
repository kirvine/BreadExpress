BreadExpress::Application.routes.draw do
  # Resource routes (maps HTTP verbs to controller actions automatically):
  resources :addresses
  resources :customers
  resources :orders

  # Semi-static page routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search

  # You can have the root of your site routed with 'root'
  root 'home#index'
end
