Rails.application.routes.draw do
  get 'packings/new'
  get 'packings/index'
  get 'packings/edit'
  get 'packings/show'
  devise_for :users

  root "static_pages#top"
  get "about" => "static_pages#about"

  resources :items do
    member do
      patch :switch_status
    end
  end

  resources :packings
end
