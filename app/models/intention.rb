class Intention < ApplicationRecord
  belongs_to :from_user, class_name: 'User'
  belongs_to :to_user,   class_name: 'User'

  validates :icon,  presence: true
  validates :label, presence: true
  validates :from_user_id, uniqueness: { scope: :to_user_id }
end
