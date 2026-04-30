module Mutations
  module Matching
    class SwipeUser < Types::BaseMutation
      argument :to_user_id, ID,     required: true
      argument :action,     String, required: true  # 'like' | 'skip'

      field :matched, Boolean, null: false
      field :errors,  [String], null: false

      def resolve(to_user_id:, action:)
        authenticate!
        result = ::Matching::SwipeUser.new.call(
          from_user_id: context[:current_user].id,
          to_user_id:   to_user_id.to_i,
          action:,
        )
        { matched: result[:matched], errors: [] }
      rescue ActiveRecord::RecordInvalid => e
        { matched: false, errors: e.record.errors.full_messages }
      end
    end
  end
end
