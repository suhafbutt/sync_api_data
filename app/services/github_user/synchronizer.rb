class GithubUser::Synchronizer
  def initialize(params)
    @params = params
  end

  def upsert!
    result = GithubUser.upsert_all(user_data, unique_by: :source_user_id)
    ServiceResult.new(success?: true, payload: result)
  end

  private

  def user_data
    @params.map do |u|
      user_names = split_name(u["name"])
      {
        source_user_id: u["id"],
        login: u["login"],
        firstname: user_names[:first_name],
        lastname: user_names[:last_name],
        avatar_url: u["avatarUrl"],
        user_type: u["__typename"],
      }
    end
  end

  def split_name(full_name)
    parts = full_name.to_s.strip.split
    {
      first_name: parts[0..-2]&.join(" ") || "",
      last_name: parts.last || "",
    }
  end
end
