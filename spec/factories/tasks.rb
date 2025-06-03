FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyText" }
    status { 1 }
    priority { 1 }
    project { nil }
    user { nil }
    creator { nil }
  end
end
