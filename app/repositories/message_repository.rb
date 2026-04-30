class MessageRepository
  def create!(sender_id:, receiver_id:, body:)
    Message.create!(sender_id:, receiver_id:, body:)
  end

  def list_between(user1_id:, user2_id:)
    Message.where(
      '(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)',
      user1_id, user2_id, user2_id, user1_id
    ).order(:created_at)
  end
end
