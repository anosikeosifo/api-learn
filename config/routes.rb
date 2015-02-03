require 'api_constraints'
MarketPlaceApi::Application.routes.draw do
  mount SabisuRails::Engine => "/sabisu_rails"
  devise_for :users
  namespace :api, defaults: { format: :json } , constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      
      resources :users, only: [:index, :show, :create, :update, :destroy] #routes only the show method for now
      resources :sessions, only: [:create, :destroy]
      resources :products, only: [:show, :index, :create]
    end
  end
end
