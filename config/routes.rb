Rails.application.routes.draw do
  namespace :api do
    api_version(
        module: "V1",
        path: {value: "v1"},
        defaults: {format: :json}
    ) do

      resources :schools

      resources :books
      resources :leads

    end
  end
end
