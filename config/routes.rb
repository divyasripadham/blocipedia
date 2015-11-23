Rails.application.routes.draw do
  get 'users/show'

  get 'home/index'
    
  devise_for :users
  root to: "home#index"
end
