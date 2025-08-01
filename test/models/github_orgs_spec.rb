require "rails_helper"

RSpec.describe GithubOrg, type: :model do
  describe "associations" do
    it "has many github_org_users" do
      assoc = described_class.reflect_on_association(:github_org_users)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:dependent]).to eq(:destroy)
    end

    it "has many github_users through github_org_users" do
      assoc = described_class.reflect_on_association(:github_users)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:through]).to eq(:github_org_users)
    end
  end

  describe "validations" do
    it "is invalid without a source_org_id" do
      org = described_class.new(name: "Example Org")
      expect(org).not_to be_valid
      expect(org.errors[:source_org_id]).to include("can't be blank")
    end

    it "is invalid without a name" do
      org = described_class.new(source_org_id: "123")
      expect(org).not_to be_valid
      expect(org.errors[:name]).to include("can't be blank")
    end

    it "is valid with both source_org_id and name" do
      org = described_class.new(source_org_id: "123", name: "Example Org")
      expect(org).to be_valid
    end
  end

  describe "dependent destroy" do
    it "destroys associated github_org_users when deleted" do
      org = FactoryBot.create(:github_org)
      user = FactoryBot.create(:github_user)
      GithubOrgUser.create!(github_org: org, github_user: user)

      expect { org.destroy }.to change { GithubOrgUser.count }.by(-1)
    end
  end
end
