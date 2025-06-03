class Api::V1::TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, only: [ :show, :update, :destroy ]

  # GET /api/v1/projects/1/tasks
  def index
    @tasks = @project.tasks
    render json: @tasks, status: :ok
  end

  # GET /api/v1/projects/1/tasks/1
  def show
    render json: @task, status: :ok
  end

  # POST /api/v1/projects/1/tasks
  def create
    @task = @project.tasks.build(task_params)
    @task.creator = @current_user

    if @task.save
      render json: @task, status: :created
    else
      render json: { errors: @task.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/projects/1/tasks/1
  def update
    if @task.update(task_params)
      render json: @task, status: :ok
    else
      render json: { errors: @task.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/projects/1/tasks/1
  def destroy
    @task.destroy
    render json: { message: "Task deleted successfully" }, status: :no_content
  end

  private

    def set_project
      @project = @current_user.projects.find(params[:project_id])
    end

    def set_task
      @task = @project.tasks.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :description, :status, :priority, :user_id)
    end
end
