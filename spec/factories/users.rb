FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    avatar_url { Faker::Internet.url }
    provider { "google" }
    uid { Faker::Alphanumeric.alphanumeric(number: 10) }
  end
end
