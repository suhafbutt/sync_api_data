class GithubOrg::Synchronizer
  def initialize(params)
    @params = params
  end

  def upsert!
    github_org.assign_attributes(@params)
    if github_org.save
      ServiceResult.new(success?: true, payload: github_org)
    else
      ServiceResult.new(success?: false, error: github_org.errors.full_messages, payload: github_org)
    end
  end

  private

  def github_org
    @github_org ||= GithubOrg.find_or_initialize_by(source_org_id: @params[:source_org_id])
  end
end
