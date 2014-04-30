Rails.application.routes.draw do
  resources :collections, only: [:index, :show]

  root 'collections#index'
end
