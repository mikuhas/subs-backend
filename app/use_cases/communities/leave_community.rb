  module Communities
    class LeaveCommunity
      def initialize(membership_repo: CommunityMembershipRepository.new)
        @membership_repo = membership_repo
      end

      def call(user_id:, community_id:)
        @membership_repo.destroy!(user_id:, community_id:)
      end
    end
  end
