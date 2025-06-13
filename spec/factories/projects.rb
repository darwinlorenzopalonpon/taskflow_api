FactoryBot.define do
  factory :project do
    name { Faker::App.name }
    description { Faker::Lorem.sentence }
    deadline { 2.weeks.from_now }
    user { association(:user) }
  end
end
