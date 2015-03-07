require 'api_constraints'
MarketPlaceApi::Application.routes.draw do
  mount SabisuRails::Engine => "/sabisu_rails"
  devise_for :users
  
  namespace :api, defaults: { format: :json } , constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      
      resources :users, only: [:index, :show, :create, :update, :destroy]  do
      	resources :products, only: [:create, :update, :destroy] #nested route, cos the products are created by users
      end
      resources :sessions, only: [:create, :destroy]
      resources :products, only: [:show, :index]
    end
  end
end
