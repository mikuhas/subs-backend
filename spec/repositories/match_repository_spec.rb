require_relative '../rails_helper'

RSpec.describe MatchRepository do
  subject(:repo) { described_class.new }

  describe '#find_or_create!' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    it 'マッチを作成できる' do
      match = repo.find_or_create!(user1_id: user1.id, user2_id: user2.id)
      expect(match).to be_persisted
    end

    it '同じペアを再度呼んでもレコードを重複作成しない' do
      repo.find_or_create!(user1_id: user1.id, user2_id: user2.id)
      expect { repo.find_or_create!(user1_id: user1.id, user2_id: user2.id) }
        .not_to change(Match, :count)
    end
  end

  describe '#list_for' do
    it 'user1側・user2側どちらのマッチも返す' do
      user1 = create(:user)
      user2 = create(:user)
      user3 = create(:user)
      create(:match, user1: user1, user2: user2)
      create(:match, user1: user2, user2: user3)
      expect(repo.list_for(user_id: user2.id).count).to eq(2)
    end

    it '無関係なユーザーのマッチは返さない' do
      user1  = create(:user)
      user2  = create(:user)
      other  = create(:user)
      create(:match, user1: user1, user2: user2)
      expect(repo.list_for(user_id: other.id)).to be_empty
    end
  end

  describe '#matched?' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    it 'マッチが存在する場合はtrueを返す' do
      u1, u2 = [user1.id, user2.id].minmax
      create(:match, user1_id: u1, user2_id: u2)
      expect(repo.matched?(user_a_id: user1.id, user_b_id: user2.id)).to be true
    end

    it 'マッチが存在しない場合はfalseを返す' do
      expect(repo.matched?(user_a_id: user1.id, user_b_id: user2.id)).to be false
    end
  end
end
