module Api
  module V1
    class ProjectsController < BaseController
      before_action :set_project, only: [ :show, :update, :destroy ]

      def index
        @projects = policy_scope(Project)
        render json: ProjectSerializer.render(@projects, view: :list)
      end

      def show
        render json: ProjectSerializer.render(@project, view: :detailed)
      end

      def create
        @project = Project.new(project_params.merge(user: current_user))
        authorize @project

        if @project.save
          @project.project_memberships.create!(
            user: current_user,
            role: "owner"
          )
          render json: ProjectSerializer.render(@project, view: :detailed),
                 status: :created
        else
          render json: { errors: @project.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def update
        authorize @project

        if @project.update(project_params)
          render json: ProjectSerializer.render(@project, view: :detailed)
        else
          render json: { errors: @project.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def destroy
        authorize @project
        @project.destroy
        head :no_content
      end

      private

      def set_project
        @project = Project.find(params[:id])
      end

      def project_params
        params.require(:project).permit(:name, :description, :deadline)
      end
    end
  end
end
