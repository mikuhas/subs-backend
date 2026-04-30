module Types
  class UserType < Types::BaseObject
    field :id,                     ID,        null: false
    field :name,                   String,    null: false
    field :age,                    Integer,   null: false
    field :bio,                    String,    null: true
    field :image_url,              String,    null: true
    field :gender,                 String,    null: true
    field :line,                   String,    null: true
    field :height,                 Integer,   null: true
    field :body_type,              String,    null: true
    field :preferred_line,         String,    null: true
    field :preferred_meeting_area, String,    null: true
    field :frequent_station,       String,    null: true
    field :first_date_station,     String,    null: true
    field :random_match_enabled,   Boolean,   null: false
    field :distance_km,            Float,     null: true
    field :community_ids,          [Integer], null: false
  end
end
