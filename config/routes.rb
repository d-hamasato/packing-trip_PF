Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    post 'users/guest_sign_in' => 'users/sessions#new_guest'
  end

  root "homes#top"
  get "about" => "homes#about"

  resources :users, only: [:show, :index, :edit, :update] do
    member do
      get :following
      get :followers
    end
    resource :relationships,only: [:create, :destroy]
  end
  resources :items do
    resource :favorites, only: [:create, :destroy]
    member do
      patch :switch_status
    end
  end
  resources :packings do
    resource :favorites, only: [:create, :destroy]
    member do
      patch :switch_status
    end
  end
  resources :blogs do
    resource :favorites, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end
  resources :uploads, only: [:create, :destroy]
  get '/search_items' => 'searches#search_items'
  get '/search_packings' => 'searches#search_packings'
  get '/search_blogs' => 'searches#search_blogs'
  get '/search_users' => 'searches#search_users'
  get '/search_all_contents' => 'searches#search_all_contents'
end
