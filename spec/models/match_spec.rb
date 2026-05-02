require_relative '../rails_helper'

RSpec.describe Match, type: :model do
  describe 'バリデーション' do
    it '同じペアのマッチは重複不可' do
      user1 = create(:user)
      user2 = create(:user)
      create(:match, user1: user1, user2: user2)
      expect(build(:match, user1: user1, user2: user2)).not_to be_valid
    end
  end

  describe '#partner_for' do
    let(:match) { create(:match) }

    it 'user1のIDを渡すとuser2を返す' do
      expect(match.partner_for(match.user1_id)).to eq(match.user2)
    end

    it 'user2のIDを渡すとuser1を返す' do
      expect(match.partner_for(match.user2_id)).to eq(match.user1)
    end
  end
end
