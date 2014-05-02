Rails.application.routes.draw do
  resources :offerings, only: [:index, :show]
  resources :orders, only: [:show, :create]

  # for TouchNet post-backs
  post '/payment', to: 'payments#update'

  root 'offerings#index'
end
