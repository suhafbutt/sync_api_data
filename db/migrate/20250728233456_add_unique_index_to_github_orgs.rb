class AddUniqueIndexToGithubOrgs < ActiveRecord::Migration[7.1]
  def change
    add_index :github_orgs, :source_org_id, unique: true
  end
end

