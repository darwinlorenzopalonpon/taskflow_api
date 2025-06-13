module Api
  module V1
    class BaseController < ApplicationController
      include Pundit::Authorization

      after_action :verify_authorized, except: :index
      after_action :verify_policy_scoped, only: :index

      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

      private

      def user_not_authorized
        render json: { error: "You are not authorized to perform this action." },
               status: :forbidden
      end

      def not_found
        render json: { error: "Not found" },
               status: :not_found
      end

      def unprocessable_entity(exception)
        render json: { error: exception.message },
               status: :unprocessable_entity
      end
    end
  end
end
