require "rails_helper"
require "ostruct"

RSpec.describe GithubOrgUsers::Synchronizer do
  let!(:github_org) { GithubOrg.create!(source_org_id: "123", name: "Docker") }
  let!(:user1) { GithubUser.create!(source_user_id: "u_1") }
  let!(:user2) { GithubUser.create!(source_user_id: "u_2") }

  describe "#upsert!" do
    context "when all github_user_ids are valid" do
      it "creates GithubOrgUser records and returns a successful ServiceResult" do
        synchronizer = described_class.new(
          github_users_ids: [user1.id, user2.id],
          github_org_id: github_org.id,
        )

        result = synchronizer.upsert!

        expect(result.success?).to eq(true)
        expect(GithubOrgUser.count).to eq(2)
        expect(result.payload.rows.size).to eq(2)
      end
    end

    context "when some records are missing in result" do
      it "returns a failed ServiceResult if fewer rows were inserted" do
        allow(GithubOrgUser).to receive(:upsert_all).and_return(OpenStruct.new(rows: [[user1.id]]))

        synchronizer = described_class.new(
          github_users_ids: [user1.id, user2.id],
          github_org_id: github_org.id,
        )

        result = synchronizer.upsert!

        expect(result.success?).to eq(false)
        expect(result.error).to eq("Some records are missig!")
      end
    end
  end
end
