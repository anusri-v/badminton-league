Rails.application.routes.draw do
  root "home#index"
  resources :players
  resources :matches
end