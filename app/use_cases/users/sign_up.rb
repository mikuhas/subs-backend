  module Users
    class SignUp
      def initialize(user_repo: UserRepository.new)
        @user_repo = user_repo
      end

      def call(email:, password:, name:, age:, gender:)
        user  = @user_repo.create!(email:, password:, name:, age:, gender:)
        token = JsonWebToken.encode(user_id: user.id)
        { user:, token: }
      end
    end
  end
