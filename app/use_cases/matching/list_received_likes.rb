module Matching
  class ListReceivedLikes
    def call(current_user_id:)
      liker_ids      = Like.where(to_user_id: current_user_id, action: 'like').pluck(:from_user_id)
      already_swiped = Like.where(from_user_id: current_user_id).pluck(:to_user_id)
      User.where(id: liker_ids - already_swiped)
    end
  end
end
