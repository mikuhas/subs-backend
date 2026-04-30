class MatchRepository
  def find_or_create!(user1_id:, user2_id:)
    Match.find_or_create_by!(user1_id:, user2_id:) { |m| m.matched_at = Time.current }
  end

  def list_for(user_id:)
    Match.where('user1_id = ? OR user2_id = ?', user_id, user_id)
         .includes(:user1, :user2)
         .order(created_at: :desc)
  end

  def matched?(user_a_id:, user_b_id:)
    u1, u2 = [user_a_id, user_b_id].minmax
    Match.exists?(user1_id: u1, user2_id: u2)
  end
end
