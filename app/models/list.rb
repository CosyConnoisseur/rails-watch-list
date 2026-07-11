class List < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :movies, through: :bookmarks

  validates :name, presence:true, uniqueness:true

    def fetch_api
      escaped_title = CGI.escape(self.name)

      url = "https://apis.scrimba.com/unsplash/photos/random?orientation=landscape&query=#{escaped_title}"

      response = Faraday.get(url)
      data = JSON.parse(response.body)
      p data
    end
end
