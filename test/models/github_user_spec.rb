require "rails_helper"

RSpec.describe GithubUser, type: :model do
  describe "associations" do
    it "has many github_org_users" do
      assoc = described_class.reflect_on_association(:github_org_users)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:dependent]).to eq(:destroy)
    end

    it "has many github_orgs through github_org_users" do
      assoc = described_class.reflect_on_association(:github_orgs)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:through]).to eq(:github_org_users)
    end
  end

  describe "validations" do
    it "is invalid without a source_user_id" do
      user = described_class.new(login: "johndoe")
      expect(user).not_to be_valid
      expect(user.errors[:source_user_id]).to include("can't be blank")
    end

    it "is valid with a source_user_id" do
      user = described_class.new(source_user_id: "12345", login: "johndoe")
      expect(user).to be_valid
    end
  end

  describe "dependent destroy" do
    it "destroys associated github_org_users when deleted" do
      user = FactoryBot.create(:github_user)
      org = FactoryBot.create(:github_org)
      GithubOrgUser.create!(github_user: user, github_org: org)

      expect { user.destroy }.to change { GithubOrgUser.count }.by(-1)
    end
  end
end
