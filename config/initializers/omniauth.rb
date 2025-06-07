OmniAuth.config.allowed_request_methods = [:get, :post]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           ENV["GOOGLE_CLIENT_ID"],
           ENV["GOOGLE_CLIENT_SECRET"],
           callback_path: "/auth/google_oauth2/callback"

  provider :github,
           ENV["GITHUB_CLIENT_ID"],
           ENV["GITHUB_CLIENT_SECRET"],
           callback_path: "/auth/github/callback"
end
