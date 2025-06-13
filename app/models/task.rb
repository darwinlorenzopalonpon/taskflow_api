class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user, optional: true
  belongs_to :creator, class_name: "User"

  enum :status, {
    pending: 0,
    in_progress: 1,
    completed: 2
  }

  enum :priority, {
    low: 0,
    medium: 1,
    high: 2
  }

  validates :title, presence: true
  validate :assigned_user_is_project_member

  private

  def assigned_user_is_project_member
    return unless user_id_changed? && user_id.present?

    return if project.project_memberships.exists?(user_id: user_id)

    errors.add(:user, "must be a member of the project")
  end
end
