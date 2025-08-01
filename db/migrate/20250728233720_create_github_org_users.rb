class CreateGithubOrgUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :github_org_users do |t|
      t.integer :github_org_id, null: false
      t.integer :github_user_id, null: false

      t.timestamps
    end

    add_index :github_org_users, [:github_org_id, :github_user_id], unique: true
    add_foreign_key :github_org_users, :github_orgs
    add_foreign_key :github_org_users, :github_users
  end
end