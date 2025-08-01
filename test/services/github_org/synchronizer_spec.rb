require "rails_helper"

RSpec.describe GithubOrg::Synchronizer do
  let(:valid_params) do
    {
      source_org_id: "org1",
      name: "Org",
      login: "org",
      description: "org stuff",
      url: "fakeorg.com",
      avatar_url: "fakeavatar.pk",
    }
  end

  describe "#upsert!" do
    context "when the org does not exist" do
      it "creates a new GithubOrg record and returns a successful ServiceResult" do
        result = described_class.new(valid_params).upsert!

        expect(result.success?).to eq(true)
        expect(result.payload).to be_a(GithubOrg)
        expect(GithubOrg.count).to eq(1)
        expect(GithubOrg.last.name).to eq("Org")
      end
    end

    context "when the org already exists" do
      before do
        GithubOrg.create!(valid_params.merge(name: "Old Org"))
      end

      it "updates the existing record and returns a successful ServiceResult" do
        updated_params = valid_params.merge(name: "New Org")
        result = described_class.new(updated_params).upsert!

        expect(result.success?).to eq(true)
        expect(GithubOrg.count).to eq(1)
        expect(GithubOrg.last.name).to eq("New Org")
      end
    end

    context "when the params are invalid" do
      it "returns a failed ServiceResult with errors" do
        invalid_params = valid_params.except(:name)
        result = described_class.new(invalid_params).upsert!

        expect(result.success?).to eq(false)
        expect(result.payload).to be_a(GithubOrg)
        expect(result.payload.errors[:name]).to be_present
      end
    end
  end
end
