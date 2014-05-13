Rails.application.routes.draw do
  namespace :admin do
    resources :users, only: [:show, :index]
    resources :orders, only: [:show, :index]
    root to: 'orders#index'
  end

  resources :offerings, only: [:index, :show]
  resources :orders, only: [:show, :create, :destroy]

  # for TouchNet post-backs
  post '/payment', to: 'payments#update'

  root 'offerings#index'
end
