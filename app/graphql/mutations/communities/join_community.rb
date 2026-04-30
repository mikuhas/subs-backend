module Mutations
  module Communities
    class JoinCommunity < Types::BaseMutation
      argument :community_id, ID, required: true

      field :errors, [String], null: false

      def resolve(community_id:)
        authenticate!
        ::Communities::JoinCommunity.new.call(
          user_id:      context[:current_user].id,
          community_id: community_id.to_i,
        )
        { errors: [] }
      rescue ActiveRecord::RecordInvalid => e
        { errors: e.record.errors.full_messages }
      end
    end
  end
end
