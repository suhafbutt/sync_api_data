class Indexes < ActiveRecord::Migration[7.1]
  def change
    add_index :github_orgs, :source_org_id, unique: true
    add_index :github_users, :source_user_id, unique: true
  end
end
