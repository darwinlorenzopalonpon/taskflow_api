FactoryBot.define do
  factory :project do
    name { "MyString" }
    description { "MyText" }
    deadline { "2025-06-02" }
    user { nil }
  end
end
