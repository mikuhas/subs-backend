class Like < ApplicationRecord
  belongs_to :from_user, class_name: 'User'
  belongs_to :to_user,   class_name: 'User'

  validates :action, inclusion: { in: %w[like skip] }
  validates :from_user_id, uniqueness: { scope: :to_user_id }
end
