Rails.application.routes.draw do
  get 'favorites/create'
  get 'favorites/destroy'
  devise_for :users

  root "static_pages#top"
  get "about" => "static_pages#about"

  resources :users, only: [:show, :index, :edit, :update]
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
  # ↓summernoteによるブログコンテンツ内の画像アップロードのため記述
  resources :uploads, only: [:create, :destroy]
end
