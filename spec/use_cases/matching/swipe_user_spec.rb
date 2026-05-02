require 'rails_helper'

RSpec.describe Matching::SwipeUser do
  let(:like_repo)  { instance_spy('LikeRepository') }
  let(:match_repo) { instance_spy('MatchRepository') }
  let(:like)       { build_stubbed(:like) }
  let(:from_id)    { 1 }
  let(:to_id)      { 2 }
  subject(:use_case) { described_class.new(like_repo:, match_repo:) }

  before { allow(like_repo).to receive(:create!).and_return(like) }

  describe '#call' do
    context 'likeアクションで相互いいねがある場合' do
      before { allow(like_repo).to receive(:mutual_like_exists?).and_return(true) }

      it 'matched: trueを返す' do
        result = use_case.call(from_user_id: from_id, to_user_id: to_id, action: 'like')
        expect(result[:matched]).to be true
      end

      it 'マッチをIDの小さい順で作成する' do
        use_case.call(from_user_id: from_id, to_user_id: to_id, action: 'like')
        expect(match_repo).to have_received(:find_or_create!).with(user1_id: from_id, user2_id: to_id)
      end

      it 'likeレコードを作成する' do
        use_case.call(from_user_id: from_id, to_user_id: to_id, action: 'like')
        expect(like_repo).to have_received(:create!).with(from_user_id: from_id, to_user_id: to_id, action: 'like')
      end
    end

    context 'likeアクションで相互いいねがない場合' do
      before { allow(like_repo).to receive(:mutual_like_exists?).and_return(false) }

      it 'matched: falseを返す' do
        result = use_case.call(from_user_id: from_id, to_user_id: to_id, action: 'like')
        expect(result[:matched]).to be false
      end

      it 'マッチを作成しない' do
        use_case.call(from_user_id: from_id, to_user_id: to_id, action: 'like')
        expect(match_repo).not_to have_received(:find_or_create!)
      end
    end

    context 'skipアクションの場合' do
      it 'matched: falseを返す' do
        result = use_case.call(from_user_id: from_id, to_user_id: to_id, action: 'skip')
        expect(result[:matched]).to be false
      end

      it '相互いいねチェックをしない' do
        use_case.call(from_user_id: from_id, to_user_id: to_id, action: 'skip')
        expect(like_repo).not_to have_received(:mutual_like_exists?)
      end

      it 'マッチを作成しない' do
        use_case.call(from_user_id: from_id, to_user_id: to_id, action: 'skip')
        expect(match_repo).not_to have_received(:find_or_create!)
      end
    end
  end
end
