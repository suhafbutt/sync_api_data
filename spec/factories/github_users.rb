FactoryBot.define do
  factory :github_user do
    sequence(:source_user_id) { |n| "user_#{n}" }
    firstname { "foobar" }
    lastname { "jack" }
  end
end
