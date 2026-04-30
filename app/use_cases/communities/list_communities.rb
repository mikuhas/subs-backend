  module Communities
    class ListCommunities
      def initialize(community_repo: CommunityRepository.new)
        @community_repo = community_repo
      end

      def call
        @community_repo.all
      end
    end
  end
