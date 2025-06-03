require 'rails_helper'

RSpec.describe "Auths", type: :request do
  describe "GET /google" do
    it "returns http success" do
      get "/auth/google"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /github" do
    it "returns http success" do
      get "/auth/github"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /me" do
    it "returns http success" do
      get "/auth/me"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /failure" do
    it "returns http success" do
      get "/auth/failure"
      expect(response).to have_http_status(:success)
    end
  end
end
