FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    name     { Faker::Name.name }
    age      { rand(18..35) }
    gender   { 'mens' }
    bio      { Faker::Lorem.sentence }
  end
end
