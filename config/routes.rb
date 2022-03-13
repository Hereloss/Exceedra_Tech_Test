# frozen_string_literal: true

Rails.application.routes.draw do
  get 'players/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post 'players/create', to: 'players#create'
  resources :players, only: %i[index show create]
  resources :matches
end
