class GithubSyncService
  def self.sync(org_name:)
    new(org_name).sync
  end

  def initialize(org_name)
    @org_name = org_name
    @api_client = GithubApiClient.new(org_name: org_name)
  end

  def sync
    error = ""
    ActiveRecord::Base.transaction do
      cursor = nil
      has_next_page = true
      begin
        while has_next_page
          org_result = @api_client.fetch_org(cursor)

          return org_result unless org_result.success?
          org = save_org_and_members(org_result.payload["organization"])
          has_next_page = next_page?(org_result.payload)
          cursor = next_cursor(org_result.payload)
        end
        return ServiceResult.new(success?: true, payload: org)
      end
    rescue => e
      error = e.message
      raise ActiveRecord::Rollback
    end
    return ServiceResult.new(success?: false, error: "Error: #{error}") if error
  end

  private

  def org_params(org_data)
    {
      source_org_id: org_data["id"],
      name: org_data["name"],
      login: org_data["login"],
      description: org_data["description"],
      url: org_data["url"],
      avatar_url: org_data["avatarUrl"],
    }
  end

  def github_user_ids(github_user_synchronizer_result)
    github_user_synchronizer_result.payload.rows.map { |e| e[0] }
  end

  def next_cursor(org_data)
    org_data.dig("organization", "membersWithRole", "pageInfo", "endCursor")
  end

  def next_page?(org_data)
    org_data.dig("organization", "membersWithRole", "pageInfo", "hasNextPage")
  end

  def save_org_and_members(org_data)
    org_synchronizer_result = GithubOrg::Synchronizer.new(org_params(org_data)).upsert!
    github_user_synchronizer_result = GithubUser::Synchronizer.new(org_data.dig("membersWithRole", "nodes")).upsert!
    GithubOrgUsers::Synchronizer.new(github_users_ids: github_user_ids(github_user_synchronizer_result),
      github_org_id: org_synchronizer_result.payload.id).upsert!
    org_synchronizer_result.payload
  end
end
