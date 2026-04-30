module Mutations
  module Communities
    class LeaveCommunity < Types::BaseMutation
      argument :community_id, ID, required: true

      field :errors, [String], null: false

      def resolve(community_id:)
        authenticate!
        ::Communities::LeaveCommunity.new.call(
          user_id:      context[:current_user].id,
          community_id: community_id.to_i,
        )
        { errors: [] }
      rescue ActiveRecord::RecordNotFound => e
        { errors: [e.message] }
      end
    end
  end
end
