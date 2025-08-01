class GithubOrgUser < ApplicationRecord
  belongs_to :github_org
  belongs_to :github_user

  validates :github_org_id, uniqueness: { scope: :github_user_id }
end
