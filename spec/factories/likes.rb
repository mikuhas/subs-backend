FactoryBot.define do
  factory :like do
    association :from_user, factory: :user
    association :to_user,   factory: :user
    action { 'like' }
  end
end
