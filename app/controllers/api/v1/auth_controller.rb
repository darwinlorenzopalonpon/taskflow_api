class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: [:google, :github, :callback, :failure]

  def google
    Rails.logger.debug "==== GOOGLE AUTH CALLBACK ===="
    handle_callback
  end

  def github
    Rails.logger.debug "==== GITHUB AUTH CALLBACK ===="
    handle_callback
  end

  def callback
    Rails.logger.debug "==== GENERIC AUTH CALLBACK ===="
    Rails.logger.debug "Provider: #{params[:provider]}"
    handle_callback
  end

  def me
    render json: { user: @current_user }
  end

  def failure
    Rails.logger.debug "==== AUTH FAILURE ===="
    Rails.logger.debug "Reason: #{params[:message]}"
    render json: { error: "Authentication failed" }, status: :unauthorized
  end

  private

  def handle_callback
    auth_hash = request.env["omniauth.auth"]
    Rails.logger.debug "Auth hash: #{auth_hash.to_json}"

    @current_user = User.find_or_create_by_oauth(auth_hash)
    token = @current_user.generate_jwt_token

    redirect_url = "#{frontend_url}?token=#{token}"
    Rails.logger.debug "Redirecting to: #{redirect_url}"

    redirect_to redirect_url
  end

  def frontend_url
    Rails.env.development? ? "http://localhost:5173" : ENV["FRONTEND_URL"]
  end
end
