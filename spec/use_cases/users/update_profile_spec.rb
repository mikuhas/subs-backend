require 'rails_helper'

RSpec.describe Users::UpdateProfile do
  let(:user_repo) { instance_spy('UserRepository') }
  let(:user)      { build_stubbed(:user, name: '更新後') }
  subject(:use_case) { described_class.new(user_repo:) }

  before { allow(user_repo).to receive(:update!).and_return(user) }

  describe '#call' do
    it '更新後のユーザーを返す' do
      result = use_case.call(user_id: user.id, name: '更新後')
      expect(result).to eq(user)
    end

    it 'user_repo.update!に正しい引数を渡す' do
      use_case.call(user_id: user.id, name: '更新後', bio: '新しい自己紹介')
      expect(user_repo).to have_received(:update!).with(user_id: user.id, name: '更新後', bio: '新しい自己紹介')
    end
  end
end
