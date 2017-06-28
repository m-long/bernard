Rails.application.routes.draw do
  # Site root
  root 'static_pages#home'

  # Whiskey Page Routes

  # Users routes
  get    '/signup',  to: 'users#new'
  post   '/signup',  to: 'users#create'
  ## No index page for users
  resources :users,  only: [:show, :new, :create, :edit, :update, :destroy]
  ## Session Routes
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  ## Routes for account activations
  resources :account_activations, only: [:edit]
  ## Routes for password resets
  resources :password_resets,     only: [:new, :create, :edit, :update]

  ## Routes for remotes
  resources :remotes, only: [:new, :create, :show, :edit, :update, :destroy]
  ## Routes for device brands
  resources :device_brands,
              only: [:new, :create, :show, :edit, :update, :destroy]
  ## Routes for remote brands
  resources :remote_brands,
              only: [:new, :create, :show, :edit, :update, :destroy]
end
