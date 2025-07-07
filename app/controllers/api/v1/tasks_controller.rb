module Api
  module V1
      class TasksController < ApplicationController
        before_action :set_task, only: [ :show, :update, :destroy ]

        def list
          tasks = Task.all.order(due_date: :asc)
          render json: tasks
        end

        def show
          render json: @task
        end

        def create
          @task = Task.new(task_params)
          if @task.save
            render json: @task, status: :created
          else
            render json: @task.errors, status: :unprocessable_entity
          end
        end

        def update
          if @task.update(task_params)
            render json: @task
          else
              render json: { erros: @task.errors.full_message }, status: :unprocessable_entity
          end
        end

        def destroy
          @task.destroy
          head :no_content
        end

        def bulk_destroy
          task_ids = params[:ids]

          if task_ids.blank?
            render json: { error: "No task IDs provided" }, status: :bad_request
          end

          # Find tasks and collect any that don't exist
          found_tasks = Task.where(id: task_ids)
          existing_ids = found_tasks.pluck(:id)
          missing_ids = task_ids.map(&:to_i) - existing_ids

          # Delete existing tasks
          deleted_count = found_tasks.delete_all

          # Build response
          response = {
            deleted_count: deleted_count,
            deleted_ids: existing_ids
          }

          # Include imssing IDs in response if any
          if missing_ids.any?
            response[:missing_ids] = missing_ids
            response[:message] = "Some tasks were not found"
          end

          render json: response, status: :ok
        rescue StandardError => e
          render json: { error: "Failed to delete tasks: #{e.message}" }, status: :internal_server_error
        end

        private

        def set_task
          @task = Task.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Task not found" }, status: :not_found
        end

        def task_params
          params.require(:task).permit(:title, :description, :status, :due_date)
        end
      end
  end
end
