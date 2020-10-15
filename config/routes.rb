Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    api_version(
      module: "V1",
      path: {value: "v1"},
      defaults: {format: :json}
    ) do

      resources :schools
      resources :books
      resources :campaigns
      resources :contacts
      resources :leads
      resources :campaign_members
      resources :opportunities

    end
  end

  post '/auth/authenticate', to: 'authentication#authenticate'
  get 'login', to: 'login#new'
  post 'login', to: 'login#create'
  #get 'users', to: 'login#index'
  delete 'logout', to: 'login#destroy'
  get 'logout', to: 'login#destroy'
  resources :users, except: [:new]
end
