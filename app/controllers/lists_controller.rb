class ListsController < ApplicationController
  def index
    @lists = List.all
    @all_movies = Movie.all
    @banner = Rails.cache.fetch("index_banner", expires_in: 1.hour) do
      MovieApiService.fetch_banner
    end
    list_names = @lists.map { |list| list.name }

    # 3. Create a hash to hold your movies per genre list
    @movie_lists = {}
    list_names.each do |genre|
      # Cleans up the string for safe cache keys (e.g., "Sci-Fi" becomes "sci_fi")
      cache_key = "#{genre.downcase.parameterize}_list"

      @movie_lists[genre] = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
        MovieApiService.fetch_list(genre.downcase)
        end
    end
  end

  def show
    @list = List.find(params[:id])
    cache_key = "list_image_#{@list.id}"

    @list_image = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      url = "https://apis.scrimba.com/unsplash/photos/random?orientation=landscape&query=#{CGI.escape(@list.name)}"
      response = Faraday.get(url)
      data = JSON.parse(response.body)
      data["urls"]["regular"]
    end
    @list_image ||= "fallback.jpg"
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    if @list.save
      redirect_to list_path(@list)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end
end
