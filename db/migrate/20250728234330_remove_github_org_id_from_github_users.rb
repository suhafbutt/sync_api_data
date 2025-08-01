class RemoveGithubOrgIdFromGithubUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :github_users, :github_org_id, :integer
  end
end
