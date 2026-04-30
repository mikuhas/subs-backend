class CommunityMembershipRepository
  def create!(user_id:, community_id:)
    ActiveRecord::Base.transaction do
      membership = CommunityMembership.create!(user_id:, community_id:, joined_at: Time.current)
      Community.increment_counter(:member_count, community_id)
      membership
    end
  end

  def destroy!(user_id:, community_id:)
    ActiveRecord::Base.transaction do
      membership = CommunityMembership.find_by!(user_id:, community_id:)
      membership.destroy!
      Community.decrement_counter(:member_count, community_id)
    end
  end
end
