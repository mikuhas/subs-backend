class Like < ApplicationRecord
  belongs_to :from_user, class_name: 'User'
  belongs_to :to_user,   class_name: 'User'

  validates :action, inclusion: { in: %w[like skip] }
  validates :from_user_id, uniqueness: { scope: :to_user_id }

  after_create :check_mutual_like

  private

  def check_mutual_like
    return unless action == 'like'

    mutual = Like.find_by(from_user_id: to_user_id, to_user_id: from_user_id, action: 'like')
    return unless mutual

    u1, u2 = [from_user_id, to_user_id].minmax
    Match.find_or_create_by!(user1_id: u1, user2_id: u2)
  end
end
