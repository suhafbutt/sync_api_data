require "rails_helper"

RSpec.describe GithubOrgUser, type: :model do
  let(:github_org) { FactoryBot.create(:github_org) }
  let(:github_user) { FactoryBot.create(:github_user) }

  describe "associations" do
    it "belongs to a github_org" do
      assoc = described_class.reflect_on_association(:github_org)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it "belongs to a github_user" do
      assoc = described_class.reflect_on_association(:github_user)
      expect(assoc.macro).to eq(:belongs_to)
    end
  end

  describe "validations" do
    it "is valid with a unique github_org and github_user" do
      org_user = described_class.new(github_org: github_org, github_user: github_user)
      expect(org_user).to be_valid
    end

    it "is invalid with a duplicate github_org and github_user pair" do
      described_class.create!(github_org: github_org, github_user: github_user)

      duplicate = described_class.new(github_org: github_org, github_user: github_user)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:github_org_id]).to include("has already been taken")
    end

    it "is valid with a duplicate github_org pair" do
      described_class.create!(github_org: github_org, github_user: github_user)
      different_github_user = FactoryBot.create(:github_user)

      duplicate = described_class.new(github_org: github_org, github_user: different_github_user)
      expect(duplicate).to be_valid
    end
  end
end
