  module Communities
    class JoinCommunity
      def initialize(membership_repo: CommunityMembershipRepository.new)
        @membership_repo = membership_repo
      end

      def call(user_id:, community_id:)
        Rails.logger.info "Communities::JoinCommunity start user_id=#{user_id} community_id=#{community_id}"
        result = @membership_repo.create!(user_id:, community_id:)
        Rails.logger.info "Communities::JoinCommunity success user_id=#{user_id} community_id=#{community_id}"
        result
      end
    end
  end
