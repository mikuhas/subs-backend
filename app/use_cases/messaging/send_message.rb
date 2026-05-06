  module Messaging
    class SendMessage
      NotMatchedError = Class.new(StandardError)

      def initialize(message_repo: MessageRepository.new, match_repo: MatchRepository.new)
        @message_repo = message_repo
        @match_repo   = match_repo
      end

      def call(sender_id:, receiver_id:, body:)
        Rails.logger.info "Messaging::SendMessage start sender_id=#{sender_id} receiver_id=#{receiver_id}"
        unless @match_repo.matched?(user_a_id: sender_id, user_b_id: receiver_id)
          Rails.logger.warn "Messaging::SendMessage failed sender_id=#{sender_id} receiver_id=#{receiver_id} reason=not_matched"
          raise NotMatchedError, 'マッチしていないユーザーにはメッセージを送れません'
        end
        message = @message_repo.create!(sender_id:, receiver_id:, body:)
        Rails.logger.info "Messaging::SendMessage success message_id=#{message.id}"
        message
      end
    end
  end
