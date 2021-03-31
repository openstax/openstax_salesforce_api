Rails.application.routes.draw do
  root 'login#new'
  use_doorkeeper
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount OpenStax::Accounts::Engine, at: '/accounts'
  mount Sidekiq::Web => '/jobs'
  namespace :api do
    api_version(
      module: 'V1',
      path: { value: 'v1' },
      defaults: { format: :json }
    ) do

      resources :schools
      resources :books
      resources :campaigns
      resources :contacts
      resources :leads
      resources :campaign_members
      resources :opportunities
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
