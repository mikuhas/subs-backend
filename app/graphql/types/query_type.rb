module Types
  class QueryType < Types::BaseObject
    field :health_check, String,                   null: false, description: 'API疎通確認'
    field :me,           Types::UserType,           null: true,  description: '認証中のユーザー'
    field :communities,  [Types::CommunityType],   null: false, description: 'コミュニティ一覧'
    field :candidates,      [Types::UserType], null: false, description: 'スワイプ候補一覧'
    field :received_likes,  [Types::UserType], null: false, description: '自分をいいねしたユーザー一覧'
    field :matches,      [Types::MatchType],        null: false, description: 'マッチ一覧'
    field :messages,     [Types::MessageType],      null: false, description: 'メッセージ一覧' do
      argument :partner_id, ID, required: true
    end

    def health_check = 'ok'

    def me
      context[:current_user]
    end

    def communities
      ::Communities::ListCommunities.new.call
    end

    def candidates
      authenticate!
      ::Matching::ListCandidates.new.call(current_user_id: context[:current_user].id)
    end

    def received_likes
      authenticate!
      ::Matching::ListReceivedLikes.new.call(current_user_id: context[:current_user].id)
    end

    def matches
      authenticate!
      ::Matching::ListMatches.new.call(user_id: context[:current_user].id)
    end

    def messages(partner_id:)
      authenticate!
      ::Messaging::ListMessages.new.call(
        user1_id: context[:current_user].id,
        user2_id: partner_id.to_i,
      )
    end

    private

    def authenticate!
      raise GraphQL::ExecutionError, '認証が必要です' unless context[:current_user]
    end
  end
end
