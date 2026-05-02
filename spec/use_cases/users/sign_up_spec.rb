require 'rails_helper'

RSpec.describe Users::SignUp do
  let(:user_repo) { instance_spy('UserRepository') }
  let(:user)      { build_stubbed(:user) }
  subject(:use_case) { described_class.new(user_repo:) }

  before { allow(user_repo).to receive(:create!).and_return(user) }

  describe '#call' do
    let(:result) do
      use_case.call(email: user.email, password: 'password', name: user.name, age: user.age, gender: user.gender)
    end

    it 'ユーザーを返す' do
      expect(result[:user]).to eq(user)
    end

    it 'JWTトークンを返す' do
      expect(result[:token]).to be_a(String)
    end

    it 'トークンにuser_idが含まれる' do
      decoded = JsonWebToken.decode(result[:token])
      expect(decoded[:user_id]).to eq(user.id)
    end

    it 'user_repo.create!に正しい引数を渡す' do
      result
      expect(user_repo).to have_received(:create!).with(
        email: user.email, password: 'password', name: user.name, age: user.age, gender: user.gender
      )
    end
  end
end
