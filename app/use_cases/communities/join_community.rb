  module Communities
    class JoinCommunity
      def initialize(membership_repo: CommunityMembershipRepository.new)
        @membership_repo = membership_repo
      end

      def call(user_id:, community_id:)
        @membership_repo.create!(user_id:, community_id:)
      end
    end
  end
