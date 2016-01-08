Rails.application.routes.draw do

  resources :wikis do
    resources :collaborators, only: [:create, :destroy]
  end

  devise_for :users

  root to: "home#index"

  resources :charges, only: [:new, :create]

  get 'users/show'

  post 'users/:user_id/downgrade' => 'users#user_downgrade', as: :user_downgrade

end
