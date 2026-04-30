  module Matching
    class ListMatches
      def initialize(match_repo: MatchRepository.new)
        @match_repo = match_repo
      end

      def call(user_id:)
        @match_repo.list_for(user_id:)
      end
    end
  end
