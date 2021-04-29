require "admin_constraint"

Rails.application.routes.draw do
  root 'login#new'
  use_doorkeeper
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount OpenStax::Accounts::Engine, at: '/accounts'
  mount Sidekiq::Web => '/jobs', :constraints => AdminConstraint.new
  get 'jobs', to: 'login#new'
  namespace :api do
    api_version(
      module: 'V1',
      path: { value: 'v1' },
      defaults: { format: :json }
    ) do

      resources :schools do
        collection do
          get 'search'
        end
      end
      resources :books do
        collection do
          get 'search'
        end
      end

      resources :campaigns
      resources :contacts do
        collection do
          get 'search'
        end
      end
      resources :leads do
        collection do
          get 'search'
        end
      end
      resources :campaign_members
      resources :opportunities do
        collection do
          get 'search'
        end
      end
      resources :users

      resources :lists, only: [:index] do
        get :subscribe
        get :unsubscribe
      end

    end
  end
  get 'login', to: 'login#new'
  post 'login', to: 'login#create'
  delete 'logout', to: 'login#destroy'

  get 'error', to: 'errors#unauthorized'
end
