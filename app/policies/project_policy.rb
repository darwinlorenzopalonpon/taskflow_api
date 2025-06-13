class ProjectPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.project_memberships.exists?(project: record)
  end

  def create?
    true
  end

  def update?
    user.project_memberships.exists?(
      project: record,
      role: ['owner', 'admin']
    )
  end

  def destroy?
    user.project_memberships.exists?(
      project: record,
      role: ['owner', 'admin']
    )
  end

  class Scope < Scope
    def resolve
      scope.joins(:project_memberships)
           .where(project_memberships: { user_id: user.id })
           .distinct
    end
  end
end
