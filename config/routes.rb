Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "root#index"
  get "/about", to: "application#about"

  resources :characters, only: [:index]
  resources :readings, only: [:index]
  resources :segments, only: [:index]
end
