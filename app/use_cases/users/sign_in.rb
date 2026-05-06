  module Users
    class SignIn
      AuthenticationError = Class.new(StandardError)

      def initialize(user_repo: UserRepository.new)
        @user_repo = user_repo
      end

      def call(email:, password:)
        Rails.logger.info "Users::SignIn start email=#{email}"
        user = @user_repo.find_by_email(email)
        unless user&.authenticate(password)
          Rails.logger.warn "Users::SignIn failed email=#{email} reason=invalid_credentials"
          raise AuthenticationError, 'メールアドレスまたはパスワードが正しくありません'
        end
        token = JsonWebToken.encode(user_id: user.id)
        Rails.logger.info "Users::SignIn success user_id=#{user.id}"
        { user:, token: }
      end
    end
  end
