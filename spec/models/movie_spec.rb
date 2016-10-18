require 'spec_helper'
require 'rails_helper'

describe Movie do
  describe 'searching Tmdb by keyword' do
    context 'with valid key' do
      it 'should call Tmdb with title keywords' do
        fakeMovies = [Tmdb::Movie.new({:title => "The Boy Whom Cried Kanye"})] 
        expect( Tmdb::Movie).to receive(:find).with('Inception').
          and_return(fakeMovies)
        allow(Tmdb::Movie).to receive(:releases).
          and_return({"id"=>10483, "countries"=>[{"certification"=>"R", "iso_3166_1"=>"US", "primary"=>false, "release_date"=>"2008-08-22"}, {"certification"=>"15", "iso_3166_1"=>"DK", "primary"=>false, "release_date"=>"2008-11-27"}, {"certification"=>"18", "iso_3166_1"=>"DE", "primary"=>false, "release_date"=>"2008-11-17"}, {"certification"=>"", "iso_3166_1"=>"TR", "primary"=>false, "release_date"=>"2008-10-17"}, {"certification"=>"", "iso_3166_1"=>"FR", "primary"=>false, "release_date"=>"2008-10-15"}, {"certification"=>"", "iso_3166_1"=>"IT", "primary"=>false, "release_date"=>"2008-11-28"}, {"certification"=>"15", "iso_3166_1"=>"GB", "primary"=>false, "release_date"=>"2008-09-26"}, {"certification"=>"MA15+", "iso_3166_1"=>"AU", "primary"=>false, "release_date"=>"2008-10-30"}, {"certification"=>"15", "iso_3166_1"=>"GR", "primary"=>false, "release_date"=>"2008-11-20"}]})
        Movie.find_in_tmdb('Inception')
      end
       it 'should return hash with title,id, release_date,rating' do
        fakeMovies = [Tmdb::Movie.new({:title => "Test",:id => 1, :release_date => "1999-10-14"})] 
        allow( Tmdb::Movie).to receive(:find).with('Inception').
          and_return(fakeMovies)
        allow(Tmdb::Movie).to receive(:releases).with(1).
          and_return({"id"=>10483, "countries"=>[{"certification"=>"R", "iso_3166_1"=>"US", "primary"=>false, "release_date"=>"2008-08-22"}, {"certification"=>"15", "iso_3166_1"=>"DK", "primary"=>false, "release_date"=>"2008-11-27"}, {"certification"=>"18", "iso_3166_1"=>"DE", "primary"=>false, "release_date"=>"2008-11-17"}, {"certification"=>"", "iso_3166_1"=>"TR", "primary"=>false, "release_date"=>"2008-10-17"}, {"certification"=>"", "iso_3166_1"=>"FR", "primary"=>false, "release_date"=>"2008-10-15"}, {"certification"=>"", "iso_3166_1"=>"IT", "primary"=>false, "release_date"=>"2008-11-28"}, {"certification"=>"15", "iso_3166_1"=>"GB", "primary"=>false, "release_date"=>"2008-09-26"}, {"certification"=>"MA15+", "iso_3166_1"=>"AU", "primary"=>false, "release_date"=>"2008-10-30"}, {"certification"=>"15", "iso_3166_1"=>"GR", "primary"=>false, "release_date"=>"2008-11-20"}]})
        allow(Movie).to receive(:get_rating_from_tmbd_id).and_return("R")
        results = Movie.find_in_tmdb('Inception')
        expect(results[0][:title]).to eq("Test")
        expect(results[0][:tmdb_id]).to eq(1)
        expect(results[0][:release_date]).to eq("1999-10-14")
        expect(results[0][:rating]).to eq("R")
      end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.find_in_tmdb('Inception') }.to raise_error(Movie::InvalidKeyError)
      end
    end
  end
  describe "create from tmdb" do
    it 'should get details from  tmdb' do
      allow(Movie).to receive(:get_rating_from_tmbd_id).and_return("R")
      expect(Tmdb::Movie).to receive(:detail).and_return({:title=>"title", :release_date => "release_date"})
      Movie.create_from_tmdb(1234)
    end
  end
  describe "get rating" do
    it 'should pull rating from hash' do
      allow(Tmdb::Movie).to receive(:releases).and_return({"id"=>10483, "countries"=>[{"certification"=>"R", "iso_3166_1"=>"US", "primary"=>false, "release_date"=>"2008-08-22"}, {"certification"=>"15", "iso_3166_1"=>"DK", "primary"=>false, "release_date"=>"2008-11-27"}, {"certification"=>"18", "iso_3166_1"=>"DE", "primary"=>false, "release_date"=>"2008-11-17"}, {"certification"=>"", "iso_3166_1"=>"TR", "primary"=>false, "release_date"=>"2008-10-17"}, {"certification"=>"", "iso_3166_1"=>"FR", "primary"=>false, "release_date"=>"2008-10-15"}, {"certification"=>"", "iso_3166_1"=>"IT", "primary"=>false, "release_date"=>"2008-11-28"}, {"certification"=>"15", "iso_3166_1"=>"GB", "primary"=>false, "release_date"=>"2008-09-26"}, {"certification"=>"MA15+", "iso_3166_1"=>"AU", "primary"=>false, "release_date"=>"2008-10-30"}, {"certification"=>"15", "iso_3166_1"=>"GR", "primary"=>false, "release_date"=>"2008-11-20"}]})
      rating= Movie::get_rating_from_tmbd_id(1)
      expect(rating).to eq("R")
    end
    it 'should set empty rating to N/A' do
      allow(Tmdb::Movie).to receive(:releases).and_return({"id"=>10483, "countries"=>[{"certification"=>"", "iso_3166_1"=>"US", "primary"=>false, "release_date"=>"2008-08-22"}, {"certification"=>"15", "iso_3166_1"=>"DK", "primary"=>false, "release_date"=>"2008-11-27"}, {"certification"=>"18", "iso_3166_1"=>"DE", "primary"=>false, "release_date"=>"2008-11-17"}, {"certification"=>"", "iso_3166_1"=>"TR", "primary"=>false, "release_date"=>"2008-10-17"}, {"certification"=>"", "iso_3166_1"=>"FR", "primary"=>false, "release_date"=>"2008-10-15"}, {"certification"=>"", "iso_3166_1"=>"IT", "primary"=>false, "release_date"=>"2008-11-28"}, {"certification"=>"15", "iso_3166_1"=>"GB", "primary"=>false, "release_date"=>"2008-09-26"}, {"certification"=>"MA15+", "iso_3166_1"=>"AU", "primary"=>false, "release_date"=>"2008-10-30"}, {"certification"=>"15", "iso_3166_1"=>"GR", "primary"=>false, "release_date"=>"2008-11-20"}]})
      rating= Movie::get_rating_from_tmbd_id(1)
      expect(rating).to eq("N/A")
    end
    it 'should set no us release to nil' do
      allow(Tmdb::Movie).to receive(:releases).and_return({"id"=>10483, "countries"=>[{"certification"=>"", "iso_3166_1"=>"RU", "primary"=>false, "release_date"=>"2008-08-22"}, {"certification"=>"15", "iso_3166_1"=>"DK", "primary"=>false, "release_date"=>"2008-11-27"}, {"certification"=>"18", "iso_3166_1"=>"DE", "primary"=>false, "release_date"=>"2008-11-17"}, {"certification"=>"", "iso_3166_1"=>"TR", "primary"=>false, "release_date"=>"2008-10-17"}, {"certification"=>"", "iso_3166_1"=>"FR", "primary"=>false, "release_date"=>"2008-10-15"}, {"certification"=>"", "iso_3166_1"=>"IT", "primary"=>false, "release_date"=>"2008-11-28"}, {"certification"=>"15", "iso_3166_1"=>"GB", "primary"=>false, "release_date"=>"2008-09-26"}, {"certification"=>"MA15+", "iso_3166_1"=>"AU", "primary"=>false, "release_date"=>"2008-10-30"}, {"certification"=>"15", "iso_3166_1"=>"GR", "primary"=>false, "release_date"=>"2008-11-20"}]})
      rating= Movie::get_rating_from_tmbd_id(1)
      expect(rating).to eq(nil)
    end
  end
end
