FactoryBot.define do
  factory :project_membership do
    user { nil }
    project { nil }
    role { "MyString" }
  end
end
