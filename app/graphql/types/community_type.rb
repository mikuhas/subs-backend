module Types
  class CommunityType < Types::BaseObject
    field :id,           ID,      null: false
    field :name,         String,  null: false
    field :tag,          String,  null: false
    field :description,  String,  null: true
    field :icon_class,   String,  null: false
    field :member_count, Integer, null: false
  end
end
