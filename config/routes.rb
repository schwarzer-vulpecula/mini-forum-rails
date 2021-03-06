Rails.application.routes.draw do
  root "home#index"

  resources :users
  get 'users/:id/posts' => 'users#posts', :as => :user_posts

  resources :posts
  post 'posts/:id/mute' => 'posts#mute', :as => :post_mute

  resources :comments, except: [:index, :new]
  post 'comments/:id/mute' => 'comments#mute', :as => :comment_mute
  get 'comments' => redirect("/posts")

  resources :replies, except: [:index, :show, :new]
  get 'replies' => redirect("/posts")

  resources :notifications, only: [:index, :destroy]
  get 'notifications/:id/' => 'notifications#index'
  delete 'notifications' => 'notifications#destroy_all'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'
  delete 'logout' => 'sessions#destroy'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
