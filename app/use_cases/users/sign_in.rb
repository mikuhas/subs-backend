  module Users
    class SignIn
      AuthenticationError = Class.new(StandardError)

      def initialize(user_repo: UserRepository.new)
        @user_repo = user_repo
      end

      def call(email:, password:)
        user = @user_repo.find_by_email(email)
        raise AuthenticationError, 'メールアドレスまたはパスワードが正しくありません' unless user&.authenticate(password)

        token = JsonWebToken.encode(user_id: user.id)
        { user:, token: }
      end
    end
  end
