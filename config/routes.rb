Rails.application.routes.draw do
  resources :collections, only: [:index, :show]
  resources :orders, only: [:show, :create]

  root 'collections#index'
end
