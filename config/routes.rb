Rails.application.routes.draw do
  root :to => 'pages#about'
  resources :responses
  resources :quizzes do
    collection do
      get 'create_test'
      post 'create_test'
    end
    member do
        get 'results'
    end
  end
  resources :sounds do
    collection do
      get 'search'
    end
  end
  resources :groups
  resources :users do
    member do
      get 'quiz_history'
      get 'test_history'
      get 'user_statistics', to: 'statistics#user_statistics', as: 'user_statistics'
      get 'open_join_group'
      post 'join_group'
    end
  end
  match '/login', to: 'sessions#new', via: :get, :as => 'login'
  match '/login/create', to: 'sessions#create', via: :post, :as => 'sessions'
  match '/about', to: 'pages#about', via: :get, :as => 'about'
  match '/logout', to: 'sessions#destroy', via: :delete, :as => 'logout'
  match '/learn', to: 'pages#learn', via: :get, :as => 'learn'
  match '/tab_groups', to: 'pages#tab_group', via: :get, :as => 'tabGroup'
  get 'data/audio/:filename', to: 'sounds#audio', as: 'audio', constraints: { filename: /[^\/]+/ }
  get '/quizzes/data/audio/:filename', to: 'sounds#audio', constraints: { filename: /[^\/]+/ }
  get '/sounds/data/audio/:filename', to: 'sounds#audio', constraints: { filename: /[^\/]+/ }
  get 'sounds/:sound_id/responses', to: 'responses#show_responses', as: 'responses_sound'
  get 'statistics/group/:join_token', to: 'statistics#group_statistics', as: 'group_statistics'
  get 'statistics/site', to: 'statistics#site_statistics', as: 'site_statistics'
  get 'search_users', to: 'users#search_users'
  post 'change_access', to: 'users#change_access'
end
