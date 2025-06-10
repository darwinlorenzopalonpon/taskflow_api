class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :google, :github, :callback, :failure ]

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

  def logout
    cookies.delete(:jwt, secure: true, http_only: true, same_site: :strict)
    render json: { message: "Logged out successfully" }
  end

  private

  def handle_callback
    auth_hash = request.env["omniauth.auth"]
    Rails.logger.debug "Auth hash: #{auth_hash.to_json}"

    @current_user = User.find_or_create_by_oauth(auth_hash)
    token = @current_user.generate_jwt_token

    cookies[:jwt] = {
      value: token,
      http_only: true,
      secure: Rails.env.production?,
      same_site: :strict,
      expires: 24.hours.from_now
    }

    redirect_to "#{frontend_url}?auth_success=true"
  end

  def frontend_url
    Rails.env.development? ? "http://localhost:5173" : ENV["FRONTEND_URL"]
  end
end
