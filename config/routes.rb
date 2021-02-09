Rails.application.routes.draw do
  devise_for :users

  root "static_pages#top"
  get "about" => "static_pages#about"

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
end
