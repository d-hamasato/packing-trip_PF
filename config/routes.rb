Rails.application.routes.draw do
  devise_for :users

  root "static_pages#top"
  get "about" => "static_pages#about"

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
end
