FactoryBot.define do
  factory :match do
    association :user1, factory: :user
    association :user2, factory: :user
    matched_at { Time.current }
  end
end
