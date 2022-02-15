require "admin_constraint"

Rails.application.routes.draw do
  # we don't really need a homepage for this API - return a 404
  # which would happen in prod anyways - but so we don't confuse devs/qas
  root to: proc { [404, {}, ['Not found. Please use API paths.']] }

  namespace :api, default: true  do
    api_version(
      module: 'V1',
      path: { value: 'v1' },
      defaults: { format: :json }
    ) do

      resources :schools, except: [:index] do
        collection do
          get 'search'
        end
      end

      resources :contacts, except: [:index] do
        collection do
          post 'add_school'
          post 'set_primary_school'
          delete 'remove_school'
        end
      end

      resources :opportunities, except: [:index, :show]

      resources :leads, only: [:create, :show]

      resources :users

      resources :lists, only: [:index] do
        get :subscribe
        get :unsubscribe
      end

      resources :books, except: :index do
        collection do
          get 'search'
        end
      end
    end
  end

  # protect all the important routes by checking the cookie if the user is an admin
  constraints(-> (req) { AdminConstraint.matches?(req) }) do
    mount Rswag::Ui::Engine => '/api-docs'
    mount Rswag::Api::Engine => '/api-docs'
    mount Sidekiq::Web => '/jobs'
    mount Blazer::Engine, at: "blazer"
    mount OpenStax::Salesforce::Engine => :openstax_salesforce
  end

  mount OpenStax::Utilities::Engine => :status
end
