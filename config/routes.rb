Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get 'login' => 'user_sessions#signin'
  post 'login' => 'user_sessions#authenticate'
  get 'logout' => 'user_sessions#signout'

  resources :users do
    collection do
      get 'list'
    end
  end

  resources :books do
    collection do
      get 'list'
    end
    resources :details
  end

  namespace :api do
    namespace :v1 do
      post 'login' => 'user_sessions#authenticate'
      resources :users, only: [:index, :show, :create, :update, :destroy]
      resources :books, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get 'search'
        end
        resources :details, only: [:create, :update, :destroy]
      end
      resources :borroweds, only: :index do
        get 'return_book'
      end
    end
  end


  # Defines the root path route ("/"),
  root "users#index"
end
