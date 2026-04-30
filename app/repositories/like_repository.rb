class LikeRepository
  def create!(from_user_id:, to_user_id:, action:)
    Like.create!(from_user_id:, to_user_id:, action:)
  end

  def mutual_like_exists?(from_user_id:, to_user_id:)
    Like.exists?(from_user_id: to_user_id, to_user_id: from_user_id, action: 'like')
  end
end
