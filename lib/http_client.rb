class HttpClient
  GITHUB_API_BASE_URL = "https://api.github.com/graphql"

  # make sure to add Github token
  def self.github
    Faraday.new(url: GITHUB_API_BASE_URL) do |f|
      f.request :url_encoded
      f.response :json, content_type: /\bjson$/
      f.headers["User-Agent"] = "RailsApp"
      f.headers["X-GitHub-Api-Version"] = "2022-11-28"
      f.headers["Accept"] = "application/vnd.github+json"
      f.headers["Authorization"] = "Bearer #{ENV["GITHUB_TOKEN"]}"
      f.adapter Faraday.default_adapter
    end
  end
end
