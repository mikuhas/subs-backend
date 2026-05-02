require_relative '../rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it '有効な属性で保存できる' do
      expect(build(:user)).to be_valid
    end

    describe 'email' do
      it 'nilは無効' do
        expect(build(:user, email: nil)).not_to be_valid
      end

      it '不正な形式は無効' do
        expect(build(:user, email: 'not-an-email')).not_to be_valid
      end

      it '重複するメールアドレスは無効' do
        create(:user, email: 'dup@example.com')
        expect(build(:user, email: 'dup@example.com')).not_to be_valid
      end
    end

    describe 'name' do
      it 'nilは無効' do
        expect(build(:user, name: nil)).not_to be_valid
      end
    end

    describe 'age' do
      it 'nilは無効' do
        expect(build(:user, age: nil)).not_to be_valid
      end

      it '17歳は無効' do
        expect(build(:user, age: 17)).not_to be_valid
      end

      it '18歳は有効' do
        expect(build(:user, age: 18)).to be_valid
      end
    end

    describe 'gender' do
      it 'nilは無効' do
        expect(build(:user, gender: nil)).not_to be_valid
      end

      it 'mens/womens以外は無効' do
        expect(build(:user, gender: 'other')).not_to be_valid
      end

      it 'mensは有効' do
        expect(build(:user, gender: 'mens')).to be_valid
      end

      it 'womensは有効' do
        expect(build(:user, gender: 'womens')).to be_valid
      end
    end
  end
end
