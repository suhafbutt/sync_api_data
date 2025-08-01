class GithubOrgUsers::Synchronizer
  def initialize(github_users_ids:, github_org_id:)
    @github_users_ids = github_users_ids
    @github_org_id = github_org_id
  end

  def upsert!
    result = GithubOrgUser.upsert_all(github_org_users_data, unique_by: %i[github_org_id github_user_id])

    if result.rows.count == @github_users_ids.count
      ServiceResult.new(success?: true, payload: result)
    else
      ServiceResult.new(success?: false, error: "Some records are missig!", payload: result)
    end
  end

  private

  def github_org_users_data
    @github_users_ids.map do |u|
      {
        github_org_id: @github_org_id,
        github_user_id: u,
      }
    end
  end
end
