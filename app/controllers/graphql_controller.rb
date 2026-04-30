class GraphqlController < ApplicationController
  def execute
    variables  = prepare_variables(params[:variables])
    query      = params[:query]
    operation  = params[:operationName]
    context    = { current_user: current_user }

    result = SubsSchema.execute(query, variables:, context:, operation_name: operation)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} },
           status: :internal_server_error
  end

  private

  def current_user
    token = request.headers['Authorization']&.split(' ')&.last
    return nil unless token

    payload = JsonWebToken.decode(token)
    return nil unless payload

    User.find_by(id: payload[:user_id])
  end

  def prepare_variables(variables_param)
    case variables_param
    when String
      variables_param.present? ? JSON.parse(variables_param) : {}
    when Hash, ActionController::Parameters
      variables_param.to_unsafe_hash
    else
      {}
    end
  end
end
