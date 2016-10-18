require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
   it 'should call the model method that performs TMDb search' do
      fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(fake_results)
      post :search_tmdb, {:TMDb => {:search_terms => 'Ted'}}
    end
    it 'should select the Search Results template for rendering' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
 
      post :search_tmdb, {:TMDb => {:search_terms => 'Ted'}}
      expect(response).to render_template('search_tmdb')
    end  
    it 'should redirect to index for nil search' do
      allow(Movie).to receive(:find_in_tmdb).and_return(Array.new())
      post :search_tmdb, {:TMDb => {:search_terms => 'Ted'}}
      expect(response).to redirect_to(movies_path)
    end 
     it 'should redirect to index for invalid search' do
      allow(Movie).to receive(:find_in_tmdb)
      post :search_tmdb, {:TMDb => {:search_terms => '   '}}
      expect(response).to redirect_to(movies_path)
    end 
    it 'should make the TMDb search results available to that template' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:TMDb => {:search_terms => 'Ted'}}
      expect(assigns(:movies)).to eq(fake_results)
    end 
  end
  describe 'add tmdb' do
    it'should call create_from_tmdb' do
      expect(Movie).to receive(:create_from_tmdb).with("1234")
      post :add_tmdb, {:checkbox_1 => 1234}
    end
    it 'should redirect to movie path' do
      allow(Movie).to receive(:create_from_tmdb).with(1234)
      post :add_tmdb, {:TMDb => {:checkbox_1 => 1234}}
      expect(response).to redirect_to(movies_path)
    end
  end
end
