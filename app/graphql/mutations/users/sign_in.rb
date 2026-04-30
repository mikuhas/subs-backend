module Mutations
  module Users
    class SignIn < Types::BaseMutation
      argument :email,    String, required: true
      argument :password, String, required: true

      field :token,  String,          null: true
      field :user,   Types::UserType, null: true
      field :errors, [String],        null: false

      def resolve(email:, password:)
        result = ::Users::SignIn.new.call(email:, password:)
        { token: result[:token], user: result[:user], errors: [] }
      rescue ::Users::SignIn::AuthenticationError => e
        { token: nil, user: nil, errors: [e.message] }
      end
    end
  end
end
