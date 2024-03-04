Rails.application.routes.draw do
  root :to => 'pages#about'
  resources :responses
  resources :quizzes do
    collection do
      get 'create_test'
      post 'create_test'
    end
  end
  resources :sounds
  resources :groups
  resources :users do
    member do
      get 'quiz_history'
      get 'open_join_group'
      post 'join_group'
    end
  end
  match '/login', to: 'sessions#new', via: :get, :as => 'login'
  match '/login/create', to: 'sessions#create', via: :post, :as => 'sessions'
  match '/about', to: 'pages#about', via: :get, :as => 'about'
  match '/learn', to: 'pages#learn', via: :get, :as => 'learn'
  match '/logout', to: 'sessions#destroy', via: :delete, :as => 'logout'
  get 'data/audio/:filename', to: 'sounds#audio', as: 'audio', constraints: { filename: /[^\/]+/ }
  get '/quizzes/data/audio/:filename', to: 'sounds#audio', constraints: { filename: /[^\/]+/ }
end
