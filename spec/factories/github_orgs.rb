FactoryBot.define do
  factory :github_org do
    sequence(:source_org_id) { |n| "org_#{n}" }
    name { "My Org" }
  end
end
