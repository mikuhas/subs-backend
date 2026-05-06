require_relative '../../rails_helper'

RSpec.describe Users::SignUp do
  let(:user_repo) { double('UserRepository') }
  let(:user)      { double('User', id: 42, email: 'test@example.com', name: 'テスト', age: 25, gender: 'mens') }
  subject(:use_case) { described_class.new(user_repo:) }

  before do
    allow(user_repo).to receive(:create!).and_return(user)
    stub_const('JsonWebToken', Module.new do
      def self.encode(payload)
        "token_user_#{payload[:user_id]}"
      end
    end)
  end

  describe '#call' do
    let(:result) do
      use_case.call(email: user.email, password: 'password', name: user.name, age: user.age, gender: user.gender)
    end

    it 'ユーザーを返す' do
      expect(result[:user]).to eq(user)
    end

    it 'トークンを返す' do
      expect(result[:token]).to be_a(String)
    end

    it 'トークンにuser_idが含まれる' do
      expect(result[:token]).to include(user.id.to_s)
    end

    it 'user_repo.create!に正しい引数を渡す' do
      result
      expect(user_repo).to have_received(:create!).with(
        email: user.email, password: 'password', name: user.name, age: user.age, gender: user.gender
      )
    end
  end
end
