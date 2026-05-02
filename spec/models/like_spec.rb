require_relative '../rails_helper'

RSpec.describe Like, type: :model do
  describe 'バリデーション' do
    it 'likeアクションは有効' do
      expect(build(:like, action: 'like')).to be_valid
    end

    it 'skipアクションは有効' do
      expect(build(:like, action: 'skip')).to be_valid
    end

    it 'like/skip以外のactionは無効' do
      expect(build(:like, action: 'invalid')).not_to be_valid
    end

    it '同じfrom_user/to_userの組み合わせは重複不可' do
      user1 = create(:user)
      user2 = create(:user)
      create(:like, from_user: user1, to_user: user2)
      expect(build(:like, from_user: user1, to_user: user2)).not_to be_valid
    end

    it '逆方向は別レコードとして有効' do
      user1 = create(:user)
      user2 = create(:user)
      create(:like, from_user: user1, to_user: user2)
      expect(build(:like, from_user: user2, to_user: user1)).to be_valid
    end
  end
end
