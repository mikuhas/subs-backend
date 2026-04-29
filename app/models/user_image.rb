class UserImage < ApplicationRecord
  belongs_to :user

  validates :image_url, presence: true
  validates :position,  presence: true, numericality: { greater_than_or_equal_to: 0 }
end
