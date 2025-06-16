Rails.application.routes.draw do
  # OmniAuth routes at root level
  get "/auth/:provider/callback", to: "api/v1/auth#callback"
  get "/auth/failure", to: "api/v1/auth#failure"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # Auth routes
      get "/auth/me", to: "auth#me"
      delete "/auth/logout", to: "auth#logout"

      # Other API resources
      resources :projects do
        resources :tasks
        resources :project_memberships
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
