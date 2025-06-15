module Api
  module V1
    class ProjectMembershipsController < BaseController
      before_action :set_project
      before_action :set_project_membership, only: [ :show, :update, :destroy ]

      def index
        @project_memberships = policy_scope(@project.project_memberships)
        authorize @project, :show?
        render json: @project_memberships
      end

      def show
        authorize @project_membership
        render json: @project_membership
      end

      def create
        @project_membership = @project.project_memberships.new
        authorize @project_membership
        @project_membership.user_id = params.dig(:project_membership, :user_id)
        allowed_roles = %w[member guest]
        provided_role = params.dig(:project_membership, :role)
        if !allowed_roles.include?(provided_role)
          render json: { error: "Invalid role" },
                 status: :unprocessable_entity
          return
        else
          @project_membership.role = provided_role
        end

        if @project.project_memberships.exists?(user_id: @project_membership.user_id)
          render json: { error: "User already a member of the project" },
                 status: :unprocessable_entity
          return
        end

        if @project_membership.save
          render json: @project_membership, status: :created
        else
          render json: { errors: @project_membership.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def update
        authorize @project_membership

        if @project_membership.role == "owner"
          render json: { error: "Project owner cannot be changed" },
                 status: :unprocessable_entity
          return
        end
        allowed_roles = %w[member guest admin]
        provided_role = params.dig(:project_membership, :role)
        if !allowed_roles.include?(provided_role)
          render json: { error: "Invalid role" },
                 status: :unprocessable_entity
          return
        else
          @project_membership.role = provided_role
        end

        if @project_membership.save
          render json: @project_membership
        else
          render json: { errors: @project_membership.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def destroy
        authorize @project_membership

        if @project_membership.role == "owner"
          render json: { error: "Project owner cannot be removed" },
                 status: :unprocessable_entity
          return
        end

        @project_membership.destroy
        head :no_content
      end

      private

      def set_project
        @project = Project.find(params[:project_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Project not found" }, status: :not_found
      end

      def set_project_membership
        @project_membership = @project.project_memberships.find(params[:id])
      end
    end
  end
end
