  module Messaging
    class ListMessages
      def initialize(message_repo: MessageRepository.new)
        @message_repo = message_repo
      end

      def call(user1_id:, user2_id:)
        @message_repo.list_between(user1_id:, user2_id:)
      end
    end
  end
