module Mutations
  module Messaging
    class SendMessage < Types::BaseMutation
      argument :receiver_id, ID,     required: true
      argument :body,        String, required: true

      field :message, Types::MessageType, null: true
      field :errors,  [String],           null: false

      def resolve(receiver_id:, body:)
        authenticate!
        message = ::Messaging::SendMessage.new.call(
          sender_id:   context[:current_user].id,
          receiver_id: receiver_id.to_i,
          body:,
        )
        { message:, errors: [] }
      rescue ::Messaging::SendMessage::NotMatchedError => e
        { message: nil, errors: [e.message] }
      rescue ActiveRecord::RecordInvalid => e
        { message: nil, errors: e.record.errors.full_messages }
      end
    end
  end
end
