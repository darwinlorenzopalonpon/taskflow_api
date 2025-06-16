class TaskSerializer < ApplicationSerializer
  identifier :id

  fields :title, :description, :status, :priority, :project_id, :created_at, :updated_at

  association :user, blueprint: UserSerializer, view: :public, name: :assigned_user
  association :creator, blueprint: UserSerializer, view: :public, name: :creator

  view :board do
    fields :id, :title, :description, :status, :priority
    association :user, blueprint: UserSerializer, view: :public, name: :assigned_user

    field :overdue do |task|
      task.deadline &&
      task.deadline < Date.today &&
      task.status != "completed"
    end

    field :days_remaining do |task|
      (task.deadline - Date.today).to_i if task.deadline
    end
  end

  view :detailed do
    fields :id, :title, :description, :status, :priority, :project_id, :created_at, :updated_at
    association :user, blueprint: UserSerializer, view: :public, name: :assigned_user
    association :creator, blueprint: UserSerializer, view: :public, name: :creator
    association :project, blueprint: ProjectSerializer, view: :detailed, name: :project
  end
end
