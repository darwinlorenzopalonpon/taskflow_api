class ProjectMembershipSerializer < ApplicationSerializer
  identifier :id

  fields :role, :created_at, :updated_at

  association :user, blueprint: UserSerializer, view: :public, name: :user
  association :project, blueprint: ProjectSerializer, view: :list, name: :project

  view :team do
    fields :id, :role
    association :user, blueprint: UserSerializer, view: :public, name: :user
  end
end
