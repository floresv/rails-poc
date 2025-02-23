# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      get :status, to: 'health#status'
      resources :categories, only: %i[index show]
      resources :meals, only: %i[index show]
      resources :wishlists, only: %i[index create destroy]
      resources :orders, only: %i[index show create destroy] do
        member do
          post :pay
        end
      end
    end
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :admin do
    authenticate(:admin_user) do
      mount Flipper::UI.app(Flipper) => '/feature-flags'
    end
  end

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
end
