Rails.application.routes.draw do
  resources :collections, only: [:index, :show]
  resources :orders, only: [:show, :create]

  # for TouchNet post-backs
  post '/payment', to: 'payments#update'

  root 'collections#index'
end
