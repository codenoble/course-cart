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

  # this is just a convenience to create a named route to rack-cas' logout
  get '/logout' => -> env { [200, { 'Content-Type' => 'text/html' }, ['Rack::CAS should have caught this']] }, as: :logout

  root 'offerings#index'
end
