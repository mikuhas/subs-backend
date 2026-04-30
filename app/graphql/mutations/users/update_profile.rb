module Mutations
  module Users
    class UpdateProfile < Types::BaseMutation
      argument :name,                   String,  required: false
      argument :bio,                    String,  required: false
      argument :age,                    Integer, required: false
      argument :gender,                 String,  required: false
      argument :height,                 Integer, required: false
      argument :body_type,              String,  required: false
      argument :line,                   String,  required: false
      argument :preferred_line,         String,  required: false
      argument :preferred_meeting_area, String,  required: false
      argument :frequent_station,       String,  required: false
      argument :first_date_station,      String,  required: false
      argument :image_url,               String,  required: false
      argument :random_match_enabled,    Boolean, required: false

      field :user,   Types::UserType, null: true
      field :errors, [String],        null: false

      def resolve(**attrs)
        authenticate!
        user = ::Users::UpdateProfile.new.call(
          user_id: context[:current_user].id,
          **attrs.reject { |_, v| v.nil? },
        )
        { user:, errors: [] }
      rescue ActiveRecord::RecordInvalid => e
        { user: nil, errors: e.record.errors.full_messages }
      end
    end
  end
end
