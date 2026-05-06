  module Users
    class UpdateProfile
      def initialize(user_repo: UserRepository.new)
        @user_repo = user_repo
      end

      def call(user_id:, **attrs)
        Rails.logger.info "Users::UpdateProfile start user_id=#{user_id} fields=#{attrs.keys.join(',')}"
        result = @user_repo.update!(user_id:, **attrs)
        Rails.logger.info "Users::UpdateProfile success user_id=#{user_id}"
        result
      end
    end
  end
