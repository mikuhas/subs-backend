module Types
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class     Types::BaseArgument
    field_class        Types::BaseField
    input_object_class Types::BaseInputObject

    private

    def authenticate!
      raise GraphQL::ExecutionError, '認証が必要です' unless context[:current_user]
    end
  end
end
