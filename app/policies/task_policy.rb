class TaskPolicy < ApplicationPolicy
  def show?
    user.project_memberships.exists?(project: record.project)
  end

  def create?
    user.project_memberships.exists?(project: record.project)
  end

  def update?
    user.project_memberships.exists?(project: record.project)
  end

  def destroy?
    user.project_memberships.exists?(
      project: record.project,
      role: [ "owner", "admin" ]
    )
  end

  class Scope < Scope
    def resolve
      scope.joins(project: :project_memberships)
           .where(project: { project_memberships: { user_id: user.id } })
           .distinct
    end
  end
end
