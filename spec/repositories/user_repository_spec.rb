require_relative '../rails_helper'

RSpec.describe UserRepository do
  subject(:repo) { described_class.new }

  describe '#find' do
    it 'IDでユーザーを取得できる' do
      user = create(:user)
      expect(repo.find(user.id)).to eq(user)
    end
  end

  describe '#find_by_email' do
    it 'メールアドレスでユーザーを取得できる' do
      user = create(:user, email: 'target@example.com')
      expect(repo.find_by_email('target@example.com')).to eq(user)
    end

    it '存在しないメールアドレスはnilを返す' do
      expect(repo.find_by_email('nobody@example.com')).to be_nil
    end
  end

  describe '#create!' do
    it 'ユーザーを作成してDBに保存する' do
      attrs = { email: 'new@example.com', password: 'pass', name: '新規', age: 22, gender: 'womens' }
      user = repo.create!(attrs)
      expect(user).to be_persisted
      expect(user.email).to eq('new@example.com')
    end
  end

  describe '#update!' do
    it 'ユーザー属性を更新して返す' do
      user = create(:user, name: '旧名前')
      updated = repo.update!(user_id: user.id, name: '新名前')
      expect(updated.name).to eq('新名前')
    end
  end

  describe '#find_candidates' do
    let!(:current_user)  { create(:user, gender: 'mens') }
    let!(:opposite_user) { create(:user, gender: 'womens') }

    it '自分自身は候補に含まれない' do
      ids = repo.find_candidates(current_user_id: current_user.id, current_user_gender: 'mens').map(&:id)
      expect(ids).not_to include(current_user.id)
    end

    it '異性が候補に含まれる' do
      ids = repo.find_candidates(current_user_id: current_user.id, current_user_gender: 'mens').map(&:id)
      expect(ids).to include(opposite_user.id)
    end

    it '同性は候補に含まれない' do
      same_gender = create(:user, gender: 'mens')
      ids = repo.find_candidates(current_user_id: current_user.id, current_user_gender: 'mens').map(&:id)
      expect(ids).not_to include(same_gender.id)
    end

    it 'スワイプ済みユーザーは候補に含まれない' do
      create(:like, from_user: current_user, to_user: opposite_user)
      ids = repo.find_candidates(current_user_id: current_user.id, current_user_gender: 'mens').map(&:id)
      expect(ids).not_to include(opposite_user.id)
    end
  end
end
