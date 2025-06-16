module Api
  module V1
    class TasksController < BaseController
      before_action :set_project
      before_action :set_task, only: [ :show, :update, :destroy ]

      def index
        @tasks = policy_scope(Task).where(project: @project)
        render json: TaskSerializer.render(@tasks, view: :board)
      end

      def show
        render json: TaskSerializer.render(@task, view: :detailed)
      end

      def create
        @task = @project.tasks.new(task_params.merge(creator: current_user))
        authorize @task

        if @task.save
          render json: TaskSerializer.render(@task, view: :detailed),
                 status: :created
        else
          render json: { errors: @task.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def update
        authorize @task

        if @task.update(task_params)
          render json: TaskSerializer.render(@task, view: :detailed)
        else
          render json: { errors: @task.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def destroy
        authorize @task
        @task.destroy
        head :no_content
      end

      private

      def set_project
        @project = Project.find(params[:project_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Project not found" }, status: :not_found
      end

      def set_task
        @task = @project.tasks.find(params[:id])
      end

      def task_params
        params.require(:task).permit(:title, :description, :status, :priority, :user_id)
      end
    end
  end
end
