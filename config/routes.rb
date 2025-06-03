Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "projects/index"
      get "projects/show"
      get "projects/create"
      get "projects/update"
      get "projects/destroy"
    end
  end
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # Auth routes
      get "/auth/:provider/callback", to: "auth#:provider"
      get "/auth/failure", to: "auth#failure"
      get "/auth/me", to: "auth#me"

      # Other API resources
      resources :projects do
        resources :tasks
      end
      resources :users, only: [ :index ]
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
