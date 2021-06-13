Rails.application.routes.draw do
  root "home#index"
  resources :posts
  resources :users
  resources :comments, except: [:index, :new]
  resources :replies, except: [:index, :show, :new]
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'
  delete 'logout' => 'sessions#destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
