require "rails_helper"

RSpec.describe HttpClient do
  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("GITHUB_TOKEN").and_return("dummy_token")
  end
  describe ".github" do
    let(:connection) { described_class.github }

    it "returns a Faraday connection" do
      expect(connection).to be_a(Faraday::Connection)
    end

    it "uses the correct base URL" do
      expect(connection.url_prefix.to_s).to eq("https://api.github.com/graphql")
    end

    it "includes the expected headers" do
      token = ENV["GITHUB_TOKEN"]
      expect(connection.headers["User-Agent"]).to eq("RailsApp")
      expect(connection.headers["Accept"]).to eq("application/vnd.github+json")
      expect(connection.headers["X-GitHub-Api-Version"]).to eq("2022-11-28")
      expect(connection.headers["Authorization"]).to eq("Bearer #{token}")
    end
  end
end
