class MovieApiService
  def self.fetch_banner
    url = "https://apis.scrimba.com/unsplash/photos/random?orientation=landscape&query=movies"
    response = Faraday.get(url)
    data = JSON.parse(response.body)
    data["urls"]["regular"]
  end

  def self.fetch_list(genre)
    response = Faraday.get("https://apis.scrimba.com/unsplash/photos/random?orientation=landscape&query=#{genre}")
    data = JSON.parse(response.body)
    data["urls"]["small"]
  end
end
