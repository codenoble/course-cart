Rails.application.routes.draw do
  resources :collections, only: [:index, :show]
  resources :orders, only: [:show, :create]
  resource :payment, only: [] do
    # TouchNet does a POST so the default PATCH on update won't work
    post :update, on: :member
  end

  root 'collections#index'
end
