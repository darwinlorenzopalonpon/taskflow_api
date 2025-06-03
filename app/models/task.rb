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
end
