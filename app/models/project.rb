class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy
  has_many :project_memberships, dependent: :destroy
  has_many :members, through: :project_memberships, source: :user

  validates :name, presence: true
  validates :description, presence: true
  validates :deadline, presence: true
  validates :user, presence: true
end
