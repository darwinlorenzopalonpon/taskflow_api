FactoryBot.define do
  factory :project_membership do
    user { association(:user) }
    project { association(:project) }
    role { "member" }

    trait :owner do
      role { "owner" }
    end

    trait :admin do
      role { "admin" }
    end
  end
end
