class ProjectSerializer < ApplicationSerializer
  identifier :id

  fields :name, :description, :deadline, :created_at, :updated_at

  association :user, blueprint: UserSerializer, view: :public, name: :owner

  view :detailed do
    fields :id, :name, :description, :deadline, :created_at, :updated_at

    association :user, blueprint: UserSerializer, view: :profile, name: :owner
    association :members, blueprint: UserSerializer, view: :public, name: :members
    association :tasks, blueprint: TaskSerializer, name: :tasks
  end

  view :list do
    fields :id, :name, :description, :deadline

    association :user, blueprint: UserSerializer, view: :public, name: :owner

    field :task_counts do |project|
      {
        total: project.tasks.count,
        pending: project.tasks.pending.count,
        in_progress: project.tasks.in_progress.count,
        completed: project.tasks.completed.count
      }
    end
  end
end
