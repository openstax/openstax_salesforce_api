Rails.application.routes.draw do
  root 'login#new'
  use_doorkeeper
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount OpenStax::Accounts::Engine, at: "/accounts"
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
      resources :users

      #Pardot list management API
      get '/lists', to: 'lists#available_lists'
      get '/lists/subscribe/:list_id/:salesforce_id', to: 'lists#subscribe'
      get '/lists/unsubscribe/:list_id/:salesforce_id', to: 'lists#unsubscribe'

    end
  end
  get 'login', to: 'login#new'
  post 'login', to: 'login#create'
  delete 'logout', to: 'login#destroy'

  get 'error', to: "errors#unauthorized"
end
