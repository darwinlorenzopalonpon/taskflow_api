class UserSerializer < ApplicationSerializer
  identifier :id

  fields :name, :email, :avatar_url, :created_at, :updated_at

  view :public do
    fields :id, :name, :avatar_url
  end

  view :profile do
    fields :id, :name, :email, :provider, :avatar_url, :created_at, :updated_at
  end
end
