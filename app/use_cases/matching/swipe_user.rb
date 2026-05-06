  module Matching
    class SwipeUser
      def initialize(like_repo: LikeRepository.new, match_repo: MatchRepository.new)
        @like_repo  = like_repo
        @match_repo = match_repo
      end

      def call(from_user_id:, to_user_id:, action:)
        Rails.logger.info "Matching::SwipeUser start from_user_id=#{from_user_id} to_user_id=#{to_user_id} action=#{action}"
        like = @like_repo.create!(from_user_id:, to_user_id:, action:)

        matched = false
        if action == 'like' && @like_repo.mutual_like_exists?(from_user_id:, to_user_id:)
          u1, u2 = [from_user_id, to_user_id].minmax
          @match_repo.find_or_create!(user1_id: u1, user2_id: u2)
          matched = true
          Rails.logger.info "Matching::SwipeUser matched user1_id=#{u1} user2_id=#{u2}"
        end

        Rails.logger.info "Matching::SwipeUser done matched=#{matched}"
        { like:, matched: }
      end
    end
  end
