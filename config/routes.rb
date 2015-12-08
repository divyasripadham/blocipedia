Rails.application.routes.draw do

  resources :wikis

  devise_for :users

  root to: "home#index"

  resources :charges, only: [:new, :create]

  get 'users/show'

end
