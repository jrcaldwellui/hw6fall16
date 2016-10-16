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
      puts("ARRAY BELOW")
      tmdbMovies.each do |m|
        puts(m.title)
        foundMovies << {:title => m.title, :tmdb_id => m.id, :release_date => m.release_date, :rating => (Tmdb::Movie.releases(m.id)["countries"][0]["certification"]) }
      end
      return foundMovies
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end
  
end
