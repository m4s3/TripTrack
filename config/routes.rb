  Rails.application.routes.draw do
    

  get 'likes/create'

  get 'likes/delete'

  get 'password_resets/new'
  get 'password_resets/edit'

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/dize',    to: 'static_pages#dize'
  get  '/diza',    to: 'static_pages#diza'
  get  '/dizr',    to: 'static_pages#dizr'
  get  '/rusers',  to: 'static_pages#rusers'
  get  '/rposts',  to: 'static_pages#rposts'
  get  '/rlikes',  to: 'static_pages#rlikes'
  get  '/rrel',  to: 'static_pages#rrel'
  get  '/rfrie',  to: 'static_pages#rfrie'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/pack'   , to: 'static_pages#pack'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get '/users',    to: 'users#index'
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout',to: 'sessions#destroy'
  post   '/'      ,to: 'microposts#create'

  
begin
  resources :users do
    member do
      get :following, :followers, :friends , :request_friends
    end
  end
end
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  
  resources :microposts,          only: [:create, :destroy] do
    member do
      get :like
    end
  end
  
  resources :relationships,       only: [:create, :destroy]
  resources :friendships,         only: [:create, :destroy, :update]
  resources :likes,               only: [:create]
end 



