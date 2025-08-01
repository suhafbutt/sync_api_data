class GithubUser < ApplicationRecord
  has_many :github_org_users, dependent: :destroy
  has_many :github_orgs, through: :github_org_users

  validates :source_user_id, presence: true
end
