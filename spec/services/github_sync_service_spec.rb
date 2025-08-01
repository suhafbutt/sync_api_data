require "rails_helper"

# NOTE: use webmock to stub the API calls (see https://github.com/bblimke/webmock)
# Do not use fixtures, instead create any required test data in the test using before
# blocks or let bindings (e.g. `FactoryBot.create(:github_user, name: "Foo")`)
# As an example, you can add a test for the happy case where an org has a single user,
# and verify that the org and user are created in the database.
# Another test could be for when an HTTP request returns a non-200 response
RSpec.describe GithubSyncService do
  describe ".sync" do
    # TODO: write tests
  end
end
