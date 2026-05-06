  module Communities
    class LeaveCommunity
      def initialize(membership_repo: CommunityMembershipRepository.new)
        @membership_repo = membership_repo
      end

      def call(user_id:, community_id:)
        Rails.logger.info "Communities::LeaveCommunity start user_id=#{user_id} community_id=#{community_id}"
        result = @membership_repo.destroy!(user_id:, community_id:)
        Rails.logger.info "Communities::LeaveCommunity success user_id=#{user_id} community_id=#{community_id}"
        result
      end
    end
  end
