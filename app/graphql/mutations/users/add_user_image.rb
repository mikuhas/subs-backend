module Mutations
  module Users
    class AddUserImage < Types::BaseMutation
      argument :image_url, String, required: true

      field :user_image, Types::UserImageType, null: true
      field :errors,     [String],             null: false

      def resolve(image_url:)
        authenticate!
        user     = context[:current_user]
        position = (user.user_images.maximum(:position) || -1) + 1
        image    = user.user_images.create!(image_url: image_url, position: position)
        { user_image: image, errors: [] }
      rescue ActiveRecord::RecordInvalid => e
        { user_image: nil, errors: e.record.errors.full_messages }
      end
    end
  end
end
