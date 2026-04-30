  module Messaging
    class SendMessage
      NotMatchedError = Class.new(StandardError)

      def initialize(message_repo: MessageRepository.new, match_repo: MatchRepository.new)
        @message_repo = message_repo
        @match_repo   = match_repo
      end

      def call(sender_id:, receiver_id:, body:)
        unless @match_repo.matched?(user_a_id: sender_id, user_b_id: receiver_id)
          raise NotMatchedError, 'マッチしていないユーザーにはメッセージを送れません'
        end

        @message_repo.create!(sender_id:, receiver_id:, body:)
      end
    end
  end
