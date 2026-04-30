module Types
  class UserImageType < Types::BaseObject
    field :id,        ID,      null: false
    field :image_url, String,  null: false
    field :position,  Integer, null: false
  end
end
