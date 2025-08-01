class GithubOrg < ApplicationRecord
  has_many :github_org_users, dependent: :destroy
  has_many :github_users, through: :github_org_users

  validates :source_org_id, :name, presence: true
end
