class ProjectMembershipPolicy < ApplicationPolicy
  def create?
    user.project_memberships.exists?(
      project: record.project,
      role: "owner"
    )
  end

  def update?
    return false if record.role == "owner"

    user.project_memberships.exists?(
      project: record.project,
      role: [ "owner", "admin" ]
    )
  end

  def destroy?
    return false if record.role == "owner"

    user.project_memberships.exists?(
      project: record.project,
      role: [ "owner", "admin" ]
    )
  end

  class Scope < Scope
    def resolve
      scope.where(project_id: user.project_memberships.select(:project_id))
    end
  end
end
