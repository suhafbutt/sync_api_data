require "rails_helper"
require "ostruct"

RSpec.describe GithubSyncService do
  let(:org_name) { "rails" }
  let(:api_client) { instance_double(GithubApiClient) }
  let(:service) { described_class.new(org_name) }

  let(:org_data_page_1) do
    {
      "organization" => {
        "id" => "ORG1",
        "name" => "Org Name",
        "login" => "org",
        "description" => "Org stuff",
        "url" => "fakeorg.com",
        "avatarUrl" => "fakeavatar.pk",
        "membersWithRole" => {
          "pageInfo" => {
            "hasNextPage" => true,
            "endCursor" => "cursor1",
          },
          "nodes" => [{ "id" => "user1", "login" => "user1" }],
        },
      },
    }
  end

  let(:org_data_page_2) do
    {
      "organization" => {
        "id" => "org2",
        "name" => "Org2 Name",
        "login" => "org2",
        "description" => "Org2 stuff",
        "url" => "fakeorg.com",
        "avatarUrl" => "fakeavatar.pk",
        "membersWithRole" => {
          "pageInfo" => {
            "hasNextPage" => false,
            "endCursor" => nil,
          },
          "nodes" => [{ "id" => "user2", "login" => "user2" }],
        },
      },
    }
  end

  before do
    allow(GithubApiClient).to receive(:new).with(org_name: org_name).and_return(api_client)
  end

  describe ".sync" do
    subject(:sync_result) { described_class.sync(org_name: org_name) }

    context "when fetching organization data succeeds" do
      let(:org_synchronizer_result) {
        instance_double("ServiceResult", success?: true, payload: instance_double("GithubOrg", id: 1))
      }
      let(:user_synchronizer_result) {
        instance_double("ServiceResult", success?: true, payload: OpenStruct.new(rows: [[1], [2]]))
      }
      let(:org_users_synchronizer_result) { instance_double("ServiceResult", success?: true, payload: nil) }

      before do
        allow(api_client).to receive(:fetch_org).with(nil).and_return(ServiceResult.new(success?: true,
          payload: org_data_page_1))
        allow(api_client).to receive(:fetch_org).with("cursor1").and_return(ServiceResult.new(success?: true,
          payload: org_data_page_2))

        allow(GithubOrg::Synchronizer).to receive(:new).and_return(instance_double("GithubOrg::Synchronizer",
          upsert!: org_synchronizer_result))
        allow(GithubUser::Synchronizer).to receive(:new).and_return(instance_double("GithubUser::Synchronizer",
          upsert!: user_synchronizer_result))
        allow(GithubOrgUsers::Synchronizer).to receive(:new).and_return(instance_double("GithubOrgUsers::Synchronizer",
          upsert!: org_users_synchronizer_result))
      end

      it "returns a successful ServiceResult with the organization payload" do
        result = sync_result
        expect(result.success?).to be_truthy
        expect(result.payload).to eq(org_synchronizer_result.payload)
      end

      it "calls fetch_org twice with proper cursors" do
        sync_result
        expect(api_client).to have_received(:fetch_org).with(nil)
        expect(api_client).to have_received(:fetch_org).with("cursor1")
      end

      it "calls the synchronizers with correct data" do
        sync_result
        expect(GithubOrg::Synchronizer).to have_received(:new).with(
          hash_including(
            source_org_id: "ORG1",
            name: "Org Name",
            login: "org",
            description: "Org stuff",
            url: "fakeorg.com",
            avatar_url: "fakeavatar.pk",
          ),
        )
        expect(GithubUser::Synchronizer).to have_received(:new).with(org_data_page_1["organization"] \
                                                ["membersWithRole"]["nodes"])
        expect(GithubOrgUsers::Synchronizer).to have_received(:new).with(
          github_users_ids: [1, 2],
          github_org_id: org_synchronizer_result.payload.id,
        ).twice
      end
    end

    context "when fetch_org returns failure" do
      before do
        allow(api_client).to receive(:fetch_org).and_return(ServiceResult.new(success?: false, error: "Not found"))
      end

      it "returns a failed ServiceResult with the error" do
        result = sync_result
        expect(result).not_to be_success
        expect(result.error).to eq("Not found")
      end
    end

    context "when ActiveRecord::NotNullViolation is raised" do
      before do
        allow(api_client).to receive(:fetch_org).and_raise(ActiveRecord::NotNullViolation.new("null value"))
      end

      it "returns a failed ServiceResult with the error message" do
        result = sync_result
        expect(result).not_to be_success
        expect(result.error).to match(/Error: null value/)
      end
    end

    context "when an unexpected error occurs" do
      before do
        allow(api_client).to receive(:fetch_org).and_raise(StandardError.new("Boom"))
      end

      it "raises an ActiveRecord::Rollback" do
        result = sync_result
        expect(result).not_to be_success
        expect(result.error).to match(/Error: Boom/)
      end
    end
  end
end
