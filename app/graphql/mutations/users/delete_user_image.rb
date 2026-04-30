module Mutations
  module Users
    class DeleteUserImage < Types::BaseMutation
      argument :id, ID, required: true

      field :errors, [String], null: false

      def resolve(id:)
        authenticate!
        image = context[:current_user].user_images.find(id)
        image.destroy!
        { errors: [] }
      rescue ActiveRecord::RecordNotFound
        { errors: ['画像が見つかりません'] }
      end
    end
  end
end
