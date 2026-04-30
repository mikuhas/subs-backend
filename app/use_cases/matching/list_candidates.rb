  module Matching
    class ListCandidates
      def initialize(user_repo: UserRepository.new)
        @user_repo = user_repo
      end

      def call(current_user_id:)
        @user_repo.find_candidates(current_user_id:)
      end
    end
  end
