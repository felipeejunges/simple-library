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
      get 'dashboardde' => 'dashboards#index'
      resources :users, only: [:index, :show, :create, :update, :destroy]
      resources :books, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get 'search'
        end
        put 'borrow'
        resources :details, only: [:show, :create, :update, :destroy], controller: 'book/details'
      end
      resources :borroweds, only: :index do
        patch 'return_book'
      end
    end
  end


  # Defines the root path route ("/"),
  root "books#index"
end
