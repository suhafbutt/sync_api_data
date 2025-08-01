class GithubApiClient
  DEFAULT_BATCH_SIZE = 30

  def initialize(org_name:, batch_size: DEFAULT_BATCH_SIZE)
    @org_name = org_name
    @client = HttpClient.github
    @batch_size = batch_size
  end

  def fetch_org(end_cursor = nil)
    response = @client.post do |req|
      req.body = {
        query: graphql_query(@org_name, end_cursor),
      }.to_json
    end

    org_data = response.body["data"]
    if org_data.present? && org_data["organization"]
      ServiceResult.new(success?: true, payload: org_data)
    else
      ServiceResult.new(success?: false, error: "Organization not found!", payload: org_data)
    end
  end

  private

  def graphql_query(org_login, after_cursor = nil)
    after = after_cursor ? %(, after: "#{after_cursor}") : ""
    <<~GRAPHQL
      query {
        organization(login: "#{org_login}") {
          id
          name
          login
          description
          url
          avatarUrl
          createdAt
          updatedAt
          membersWithRole(first: #{@batch_size}#{after}) {
            pageInfo {
              hasNextPage
              endCursor
            }
            nodes {
              id
              login
              name
              avatarUrl
              __typename
              ... on User {
                name
              }
            }
          }
        }
      }
    GRAPHQL
  end
end
