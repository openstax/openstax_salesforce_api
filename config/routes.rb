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
      resources :users

      #Pardot list management API
      get '/lists', to: 'lists#available_lists'
      get '/lists/subscribe/:list_id/:salesforce_id', to: 'lists#subscribe'
      get '/lists/unsubscribe/:list_id/:salesforce_id', to: 'lists#unsubscribe'

    end
  end
end
