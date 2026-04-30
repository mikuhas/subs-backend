  module Users
    class UpdateProfile
      def initialize(user_repo: UserRepository.new)
        @user_repo = user_repo
      end

      def call(user_id:, **attrs)
        @user_repo.update!(user_id:, **attrs)
      end
    end
  end
