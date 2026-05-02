require 'rails_helper'

RSpec.describe Users::SignIn do
  let(:user_repo) { instance_spy('UserRepository') }
  let(:user)      { build_stubbed(:user) }
  subject(:use_case) { described_class.new(user_repo:) }

  describe '#call' do
    context '正しい認証情報の場合' do
      before do
        allow(user_repo).to receive(:find_by_email).with(user.email).and_return(user)
        allow(user).to receive(:authenticate).with('password123').and_return(user)
      end

      it 'ユーザーを返す' do
        result = use_case.call(email: user.email, password: 'password123')
        expect(result[:user]).to eq(user)
      end

      it 'JWTトークンを返す' do
        result = use_case.call(email: user.email, password: 'password123')
        expect(result[:token]).to be_a(String)
      end
    end

    context 'パスワードが間違っている場合' do
      before do
        allow(user_repo).to receive(:find_by_email).with(user.email).and_return(user)
        allow(user).to receive(:authenticate).with('wrong').and_return(false)
      end

      it 'AuthenticationErrorを発生させる' do
        expect { use_case.call(email: user.email, password: 'wrong') }
          .to raise_error(Users::SignIn::AuthenticationError)
      end
    end

    context 'メールアドレスが存在しない場合' do
      before { allow(user_repo).to receive(:find_by_email).and_return(nil) }

      it 'AuthenticationErrorを発生させる' do
        expect { use_case.call(email: 'nobody@example.com', password: 'password') }
          .to raise_error(Users::SignIn::AuthenticationError)
      end
    end
  end
end
