class User < ApplicationRecord
  has_many :projects
  has_many :project_memberships
  has_many :member_projects, through: :project_memberships, source: :project
  has_many :tasks
  has_many :created_tasks, class_name: "Task", foreign_key: "creator_id"

  validates :email, presence: true, uniqueness: true

  def self.find_or_create_by_oauth(auth_hash)
    user = find_or_initialize_by(email: auth_hash.info.email)

    if user.new_record?
      user.assign_attributes(
        name: auth_hash.info.name,
        avatar_url: auth_hash.info.image,
        provider: auth_hash.provider,
        uid: auth_hash.uid
      )
      user.save!
    end

    user
  end

  def generate_jwt_token
    payload = {
      user_id: id,
      email: email,
      exp: 24.hours.from_now.to_i
    }

    JWT.encode(payload, Rails.application.secret_key_base)
  end
end
