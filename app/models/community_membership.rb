class CommunityMembership < ApplicationRecord
  belongs_to :user
  belongs_to :community

  validates :user_id, uniqueness: { scope: :community_id }

  after_create  { community.increment!(:member_count) }
  after_destroy { community.decrement!(:member_count) }
end
