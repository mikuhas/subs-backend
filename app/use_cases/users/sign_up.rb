  module Users
    class SignUp
      def initialize(user_repo: UserRepository.new)
        @user_repo = user_repo
      end

      def call(email:, password:, name:, age:, gender:)
        Rails.logger.info "Users::SignUp start email=#{email}"
        user  = @user_repo.create!(email:, password:, name:, age:, gender:)
        token = JsonWebToken.encode(user_id: user.id)
        Rails.logger.info "Users::SignUp success user_id=#{user.id}"
        { user:, token: }
      end
    end
  end
