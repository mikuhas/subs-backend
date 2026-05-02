require 'rails_helper'

RSpec.describe LikeRepository do
  subject(:repo) { described_class.new }

  describe '#create!' do
    it 'likeレコードを作成してDBに保存する' do
      user1 = create(:user)
      user2 = create(:user)
      like = repo.create!(from_user_id: user1.id, to_user_id: user2.id, action: 'like')
      expect(like).to be_persisted
      expect(like.action).to eq('like')
    end
  end

  describe '#mutual_like_exists?' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    it '相互いいねがある場合はtrueを返す' do
      create(:like, from_user: user1, to_user: user2, action: 'like')
      create(:like, from_user: user2, to_user: user1, action: 'like')
      expect(repo.mutual_like_exists?(from_user_id: user1.id, to_user_id: user2.id)).to be true
    end

    it '片方だけいいねした場合はfalseを返す' do
      create(:like, from_user: user1, to_user: user2, action: 'like')
      expect(repo.mutual_like_exists?(from_user_id: user1.id, to_user_id: user2.id)).to be false
    end

    it '相手がskipした場合はfalseを返す' do
      create(:like, from_user: user1, to_user: user2, action: 'like')
      create(:like, from_user: user2, to_user: user1, action: 'skip')
      expect(repo.mutual_like_exists?(from_user_id: user1.id, to_user_id: user2.id)).to be false
    end
  end
end
