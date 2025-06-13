FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyText" }
    status { 'pending' }
    priority { 'low' }
    project { association(:project) }
    user { }
    creator { association(:user) }
  end
end
