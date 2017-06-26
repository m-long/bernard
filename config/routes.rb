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
end