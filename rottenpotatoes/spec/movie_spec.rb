require 'rails_helper'

if RUBY_VERSION>='2.6.0'
  if Rails.version < '5'
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        # hack to avoid MonitorMixin double-initialize error:
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
  else
    puts "Monkeypatch for ActionController::TestResponse no longer needed"
  end
end 

RSpec.describe Movie, type: :model do

    describe "get all ratings" do
        it 'returns all ratings' do
            expect(Movie.all_ratings).to match(%w(G PG PG-13 NC-17 R))
        end
    end
    
    describe "search movie with same director" do
        before do
        @testmovie1 = Movie.create!({
            :id => 100,
            :title => "Movie A", 
            :rating => "G", 
            :description => "This is a movie description",
            :release_date => "2022-12-04", 
            :director => "Some director"})
        end
        
        it "should search for the same director" do
            expect(Movie.search_similar_movies("Some director")).to include(@testmovie1)
        end
    end
end