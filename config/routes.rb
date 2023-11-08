Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get 'login' => 'user_sessions#signin'
  post 'login' => 'user_sessions#authenticate'
  get 'logout' => 'user_sessions#signout'

  resources :users do
    collection do
      get 'list'
    end

    resources :books
  end

  resources :books do
    collection do
      get 'list'
    end

    resources :details
  end

  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :create, :update, :destroy]
    end
  end


  # Defines the root path route ("/"),
  root "users#index"
end
