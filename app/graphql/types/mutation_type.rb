module Types
  class MutationType < Types::BaseObject
    # 認証不要
    field :sign_up, mutation: Mutations::Users::SignUp
    field :sign_in, mutation: Mutations::Users::SignIn

    # 認証必要（各 Mutation 内で authenticate! を呼ぶ）
    field :update_profile,   mutation: Mutations::Users::UpdateProfile
    field :add_user_image,   mutation: Mutations::Users::AddUserImage
    field :delete_user_image, mutation: Mutations::Users::DeleteUserImage
    field :join_community,  mutation: Mutations::Communities::JoinCommunity
    field :leave_community, mutation: Mutations::Communities::LeaveCommunity
    field :swipe_user,      mutation: Mutations::Matching::SwipeUser
    field :send_message,    mutation: Mutations::Messaging::SendMessage
  end
end
