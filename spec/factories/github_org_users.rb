FactoryBot.define do
  factory :github_org_users do
    association :github_org
    association :github_user
  end
end
