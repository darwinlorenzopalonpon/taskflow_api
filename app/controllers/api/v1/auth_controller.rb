class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :google, :github, :failure ]

  def google
    handle_callback
  end

  def github
    handle_callback
  end

  def me
    render json: { user: @current_user }
  end

  def failure
    render json: { error: "Authentication failed" }, status: :unauthorized
  end

  private

  def handle_callback
    @current_user = User.find_or_create_by_oauth(request.env["omniauth.auth"])
    token = @current_user.generate_jwt_token
    redirect_to "#{frontend_url}?token=#{token}"
  end

  def frontend_url
    Rails.env.development? ? "http://localhost:5173" : ENV["FRONTEND_URL"]
  end
end
