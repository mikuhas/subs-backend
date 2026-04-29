class Community < ApplicationRecord
  has_many :community_memberships, dependent: :destroy
  has_many :users, through: :community_memberships

  validates :name,       presence: true
  validates :tag,        presence: true
  validates :icon_class, presence: true

  def as_api_json
    {
      id:          id,
      name:        name,
      tag:         tag,
      description: description.to_s,
      iconClass:   icon_class,
      memberCount: member_count,
    }
  end
end
