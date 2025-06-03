class ProjectMembership < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates_uniqueness_of :user_id, scope: :project_id
  validates :role, inclusion: { in: %w[owner admin member viewer] }

  before_validation :set_default_role

  private

  def set_default_role
    self.role ||= "member"
  end
end
