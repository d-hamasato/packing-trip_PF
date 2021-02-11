Rails.application.routes.draw do
  devise_for :users

  root "static_pages#top"
  get "about" => "static_pages#about"

  resources :users, only: [:show, :index, :edit, :update]
  resources :items do
    member do
      patch :switch_status
    end
  end
  resources :packings do
    member do
      patch :switch_status
    end
  end
  resources :blogs
  # ↓summernoteによるブログコンテンツ内の画像アップロードのため記述
  resources :uploads, only: [:create, :destroy]
end
