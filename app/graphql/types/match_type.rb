module Types
  class MatchType < Types::BaseObject
    field :id,         ID,              null: false
    field :partner,    Types::UserType, null: false
    field :matched_at, GraphQL::Types::ISO8601DateTime, null: false

    def partner
      object.partner_for(context[:current_user].id)
    end

    def matched_at
      object.created_at
    end
  end
end
