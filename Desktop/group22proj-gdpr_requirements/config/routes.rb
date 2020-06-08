Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  get '/home/live_chat', to: 'home#live_chat', as: :home_live_chat
  get '/contests/:id/evaluate', to: 'contests#evaluate', as: :contest_evaluate
  post '/contests/:id/evaluate', to: 'contests#submit_ranking', as: :contest_submit_ranking
  get '/connect/oauth', to: 'home#my_contests', as: :contest_connect_stripe

  get 'sessions/create'
  get 'sessions/destroy'

  resources :contests do
    resources :submissions, only: [:index, :new, :create, :destroy]
    resources :videos, only: [:new, :create, :destroy]
  end

  resources :conversations, only: [:create] do
    member do
      post :close
    end
    resources :messages, only: [:create]
  end

  root 'home#home'
  get '/leaderboard', to:'home#leaderboard'
  get '/my_contests', to: 'home#my_contests'
  get '/my_submissions', to: 'home#my_submissions'
  get '/home', to: 'home#home'
  get '/users', to: 'home#home'
  #how does submission routing work?
  # get '/submission'
  # get '/like' ??
  #

  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: :logout




  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
