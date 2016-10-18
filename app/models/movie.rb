class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
 class Movie::InvalidKeyError < StandardError ; end
  
  def self.find_in_tmdb(string)
    begin
      Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
      
      tmdbMovies = Tmdb::Movie.find(string)
      foundMovies = Array.new
      tmdbMovies.each do |m|
        rating = get_rating_from_tmbd_id(m.id)
        if(rating)
          foundMovies << {:title => m.title, :tmdb_id => m.id, :release_date => m.release_date, :rating => rating}
        end
      end
      
      return foundMovies
      
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end
  
  def self.create_from_tmdb (tmdb_id)
      rating = get_rating_from_tmbd_id(tmdb_id)
      movie = Tmdb::Movie.detail(tmdb_id)
      dbMovie = Movie.new({:title=>movie["title"], :release_date => movie["release_date"], :rating => rating})
      dbMovie.save
      
  end
  
  #param tmdb_id
  #returns string of US rating or nill if wasnt released in US and N/A if rating couldnt be found
  def self.get_rating_from_tmbd_id(tmdb_id)
    countryReleaseData = Tmdb::Movie.releases(tmdb_id)["countries"]
    rating = nil
    if(countryReleaseData && !countryReleaseData.empty?)
      countryReleaseData.each do |country|
        if(country["iso_3166_1"] == "US")
          rating = country["certification"]
          if(rating.empty?) 
            rating = "N/A"
          end
        end
      end
    end
    return rating
  end
  

  
end
