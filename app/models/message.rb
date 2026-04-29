class Message < ApplicationRecord
  belongs_to :sender,   class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :body, presence: true

  def as_api_json(current_user_id:)
    {
      id:        id,
      text:      body,
      fromMe:    sender_id == current_user_id,
      timestamp: created_at.to_i * 1000,  # JS の Date.now() に合わせてミリ秒
    }
  end
end
