Rails.application.routes.draw do
  devise_for :users

  # Raiz: se autenticado manda pro dashboard, senão para landing pública
  authenticated :user do
    root "dashboard#index", as: :authenticated_root
  end
  root "home#index"

  get "dashboard", to: "dashboard#index", as: :dashboard

  resources :categories
  resources :transactions

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
