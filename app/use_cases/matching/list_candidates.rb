  module Matching
    class ListCandidates
      def initialize(user_repo: UserRepository.new)
        @user_repo = user_repo
      end

      def call(current_user_id:, current_user_gender: nil)
        @user_repo.find_candidates(current_user_id:, current_user_gender:)
      end
    end
  end
