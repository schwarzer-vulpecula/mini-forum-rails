Rails.application.routes.draw do
  root "home#index"
  get 'faq' => 'home#faq'

  resources :posts

  resources :users
  get 'users/:id/posts' => 'users#posts', :as => :user_posts

  resources :comments, except: [:index, :new]
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
