module AuthHelper
  # returns headers with a valid jwt cookie set
  def auth_cookie_for(user)
    token = user.generate_jwt_token
    {
      'Cookie' => "jwt=#{token}",
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
  end
end

RSpec.configure { |c| c.include AuthHelper }
