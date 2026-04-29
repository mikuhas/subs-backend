class User < ApplicationRecord
  has_secure_password

  has_many :user_images, -> { order(:position) }, dependent: :destroy
  has_many :community_memberships, dependent: :destroy
  has_many :communities, through: :community_memberships

  has_many :sent_messages,     class_name: 'Message', foreign_key: :sender_id,   dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: :receiver_id, dependent: :destroy

  has_many :sent_likes,     class_name: 'Like', foreign_key: :from_user_id, dependent: :destroy
  has_many :received_likes, class_name: 'Like', foreign_key: :to_user_id,   dependent: :destroy

  has_many :sent_intentions,     class_name: 'Intention', foreign_key: :from_user_id, dependent: :destroy
  has_many :received_intentions, class_name: 'Intention', foreign_key: :to_user_id,   dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name,  presence: true
  validates :age,   presence: true, numericality: { greater_than_or_equal_to: 18 }

  def sub_image_urls
    user_images.map(&:image_url)
  end

  def as_match_json
    {
      id:           id,
      name:         name,
      age:          age,
      bio:          bio.to_s,
      image:        image_url.to_s,
      subImages:    sub_image_urls,
      line:         line.to_s,
      communityIds: community_ids,
      distanceKm:   distance_km.to_f,
    }
  end
end
