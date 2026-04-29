class Match < ApplicationRecord
  belongs_to :user1, class_name: 'User'
  belongs_to :user2, class_name: 'User'

  validates :user1_id, uniqueness: { scope: :user2_id }

  def partner_for(user_id)
    user1_id == user_id ? user2 : user1
  end
end
