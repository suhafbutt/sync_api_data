class AddTables < ActiveRecord::Migration[7.1]
  def change
    create_table :github_orgs do |t|
      t.string :source_org_id, null: false
      t.string :name, null: false
      t.string :login
      t.string :description
      t.string :url
      t.string :avatar_url

      t.timestamps
    end

    create_table :github_users do |t|
      t.string :source_user_id, null: false
      t.references :github_org, null: false, foreign_key: true
      t.string :login
      t.string :firstname
      t.string :lastname
      t.string :avatar_url
      t.string :user_type

      t.timestamps
    end
  end
end
