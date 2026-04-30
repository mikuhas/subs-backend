module Api
  module V1
    class BaseController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound,       with: :not_found
      rescue_from ActiveRecord::RecordInvalid,        with: :unprocessable
      rescue_from ActionController::ParameterMissing, with: :bad_request

      private

      def current_user
        token = request.headers['Authorization']&.split(' ')&.last
        return nil unless token

        payload = JsonWebToken.decode(token)
        return nil unless payload

        User.find_by(id: payload[:user_id])
      rescue
        nil
      end

      def authenticate_user!
        render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
      end

      def not_found(e)
        render json: { error: e.message }, status: :not_found
      end

      def unprocessable(e)
        render json: { error: e.message, details: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      def bad_request(e)
        render json: { error: e.message }, status: :bad_request
      end
    end
  end
end
