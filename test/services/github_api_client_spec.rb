require "rails_helper"
require "webmock/rspec"

RSpec.describe GithubApiClient do
  let(:org_name) { "docker" }
  let(:batch_size) { 2 }
  let(:client) { described_class.new(org_name: org_name, batch_size: batch_size) }
  let(:graphql_url) { "https://api.github.com/graphql" }

  let(:success_body) do
    {
      data: {
        organization: {
          id: "ebviqo12c",
          name: "Org Name",
          login: "org",
          description: "org stuff",
          url: "fakeorg.com",
          avatarUrl: "fakeavatar.pk",
          membersWithRole: {
            pageInfo: {
              hasNextPage: false,
              endCursor: nil,
            },
            nodes: [],
          },
        },
      },
    }
  end

  let(:not_found_body) do
    {
      data: {
        organization: nil,
      },
    }
  end

  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("GITHUB_TOKEN").and_return("dummy_token")
  end

  describe "#fetch_org" do
    context "when organization exists" do
      before do
        stub_request(:post, graphql_url).to_return(
          status: 200,
          body: success_body.to_json,
          headers: { "Content-Type" => "application/json" },
        )
      end

      it "returns a successful ServiceResult" do
        result = client.fetch_org
        expect(result).to be_success
        expect(result.payload["organization"]["login"]).to eq("org")
      end
    end

    context "when organization is not found" do
      before do
        stub_request(:post, graphql_url).to_return(
          status: 200,
          body: not_found_body.to_json,
          headers: { "Content-Type" => "application/json" },
        )
      end

      it "returns a failed ServiceResult" do
        result = client.fetch_org
        expect(result).not_to be_success
        expect(result.error).to eq("Organization not found!")
      end
    end
  end
end
