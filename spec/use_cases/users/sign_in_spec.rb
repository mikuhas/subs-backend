require_relative '../../spec_helper'
require_relative '../../../app/use_cases/users/sign_in'

RSpec.describe Users::SignIn do
  let(:user_repo) { double('UserRepository') }
  let(:user)      { double('User', id: 1, email: 'test@example.com') }
  subject(:use_case) { described_class.new(user_repo:) }

  before do
    stub_const('JsonWebToken', Module.new do
      def self.encode(payload)
        "token_user_#{payload[:user_id]}"
      end
    end)
  end

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

      it 'トークンを返す' do
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
