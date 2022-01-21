require "admin_constraint"

Rails.application.routes.draw do
  root 'login#new'
  use_doorkeeper
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount OpenStax::Accounts::Engine, at: '/accounts'
  mount Sidekiq::Web => '/jobs', :constraints => AdminConstraint.new
  get 'jobs', to: 'redirect#index'
  namespace :api do
    api_version(
      module: 'V1',
      path: { value: 'v1' },
      defaults: { format: :json }
    ) do

      resources :schools, except: :index do
        collection do
          get 'search'
        end
      end

      resources :contacts, except: [:index, :show] do
        collection do
          post 'add_school'
          post 'set_primary_school'
          delete 'remove_school'
        end
      end

      resources :opportunities, except: [:index, :show]

      resources :leads, except: [:index, :show, :search]

      resources :users

      resources :lists, only: [:index] do
        get :subscribe
        get :unsubscribe
      end

      ##############################
      # commented out for later use
      # resources :books, except: :index do
      #   collection do
      #     get 'search'
      #   end
      # end
      #
      # resources :campaigns, except: :index
      #
      # resources :leads, except: :index do
      #   collection do
      #     get 'search'
      #   end
      # end
      #
      # resources campaign_members: :index
      # ##################################
    end
  end
  get 'login', to: 'login#new'
  post 'login', to: 'login#create'
  delete 'logout', to: 'login#destroy'

  get 'error', to: 'errors#unauthorized'

  mount OpenStax::Utilities::Engine => :status
end
