class UserRepository
  def find(id)
    User.find(id)
  end

  def find_by_email(email)
    User.find_by(email:)
  end

  def create!(attributes)
    User.create!(attributes)
  end

  def update!(user_id:, **attrs)
    user = User.find(user_id)
    user.update!(attrs)
    user
  end

  OPPOSITE_GENDER = { 'mens' => 'womens', 'womens' => 'mens' }.freeze

  def find_candidates(current_user_id:, current_user_gender: nil)
    swiped_ids = Like.where(from_user_id: current_user_id).pluck(:to_user_id)
    scope = User.where.not(id: [current_user_id, *swiped_ids])
    if (opposite = OPPOSITE_GENDER[current_user_gender])
      scope = scope.where(gender: opposite)
    end
    scope
  end
end
