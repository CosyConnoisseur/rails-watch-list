class Movie < ApplicationRecord
  has_many :bookmarks

  validates :title, presence:true, uniqueness:true
  validates :overview, presence:true

    def fetch_api
      escaped_title = CGI.escape(self.title)

      url = "http://www.omdbapi.com/?t=#{escaped_title}&apikey=facedef2"

      response = Faraday.get(url)
      data = JSON.parse(response.body)
      p data
    end
end
