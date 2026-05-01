module Mutations
  module Users
    class SignUp < Types::BaseMutation
      argument :email,    String,  required: true
      argument :password, String,  required: true
      argument :name,     String,  required: true
      argument :age,      Integer, required: true
      argument :gender,   String,  required: true

      field :token,  String,          null: true
      field :user,   Types::UserType, null: true
      field :errors, [String],        null: false

      def resolve(email:, password:, name:, age:, gender:)
        result = ::Users::SignUp.new.call(email:, password:, name:, age:, gender:)
        { token: result[:token], user: result[:user], errors: [] }
      rescue ActiveRecord::RecordInvalid => e
        { token: nil, user: nil, errors: e.record.errors.full_messages }
      end
    end
  end
end
