module Types
  class MessageType < Types::BaseObject
    field :id,        ID,      null: false
    field :text,      String,  null: false
    field :from_me,   Boolean, null: false
    field :timestamp, GraphQL::Types::ISO8601DateTime, null: false

    def text
      object.body
    end

    def from_me
      object.sender_id == context[:current_user]&.id
    end

    def timestamp
      object.created_at
    end
  end
end
