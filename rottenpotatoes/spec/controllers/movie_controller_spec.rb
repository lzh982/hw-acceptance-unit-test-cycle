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
RSpec.describe MoviesController , :type => :controller do

    describe "create a post request" do
        it "should post to a new movie" do
            post:create, :movie => {
                title:"Your Name",
                rating: "G",
                description: "This is a movie",
                release_date: "2019-9-10",
                director: "Makoto Shinkai"
            }
            expect(Movie).to redirect_to(movies_path)
        end
    end
        
    describe "get quest for show method" do
        let!(:movie) {Movie.create!({
            :title => "Movie A", 
            :rating => "G", 
            :description => "This is a movie description",
            :release_date => "2022-12-04", 
            :director => "Some director"})
        }
            
        before :each do
            get :show, :id => movie.id
        end
        
        it "should find the movie that was created" do
            expect(assigns(:movie)).to eq(movie)
        end

        it "should generate a new page" do
            expect(response).to render_template('show')
        end
    end  

    describe "get index method" do

        it "should render index template" do
            get:index
            expect(response).to render_template('index')
        end
        it "should have instance variable for title_header" do
            get:index,:sort => 'title'
            expect(assigns(:title_header)).to eq('hilite')
        end
        it "should have instance variable for release_date" do
            get:index,:sort => 'release_date'
            expect(assigns(:date_header)).to eq('hilite')
        end
    end
    
    describe "Get search_director" do 
        before do
            @testmovie1 = Movie.create!({
            :id => 100,
            :title => "Movie A", 
            :rating => "G", 
            :description => "This is a movie description",
            :release_date => "2022-12-04", 
            :director => "Some director"})
            
            @testmovie2 = Movie.create!({
            :id => 101,
            :title => "Movie B", 
            :rating => "G", 
            :description => "This is a movie description",
            :release_date => "2022-12-04", 
            :director => "Some director"})
            
            @testmovie3 = Movie.create!({
            :id => 102,
            :title => "Movie C", 
            :rating => "G", 
            :description => "This is a movie description",
            :release_date => "2022-12-04"})
        end 
        it "should have a happy path" do
            get :similar, :id => 100
            expect(response).to render_template("similar")
        end
        it "should have a sad path" do
            get :similar, :id => 102
            expect(response).to redirect_to movies_path
        end
    end
    
    describe "new method test" do
        let(:movie) {Movie.new}
        it "should render new template" do
            get :new
            expect(response).to render_template('new')
        end
    end

    describe "create method" do
        it "post to a new movie" do
            post :create, :movie => {
            :id => 100,
            :title => "Movie A", 
            :rating => "G", 
            :description => "This is a movie description",
            :release_date => "2022-12-04", 
            :director => "Some director"}
            
            expect(Movie).to redirect_to movies_path
    
        end
    end

    describe "get edit mothod" do
        before do
         @testmovie1 = Movie.create!({
            :id => 100,
            :title => "Movie A", 
            :rating => "G", 
            :description => "This is a movie description",
            :release_date => "2022-12-04", 
            :director => "Some director"})
        end
        it "should render edit page" do
            get :edit, :id => @testmovie1.id
            expect(response).to render_template('edit')
        end
    end

    describe "patch update method" do
        before do
        @testmovie1 = Movie.create!({
            :id => 100,
            :title => "Movie A", 
            :rating => "G", 
            :description => "This is a movie description",
            :release_date => "2022-12-04", 
            :director => "Some director"})
        end
        it "should update the patch" do
            patch :update, :id => @testmovie1.id, 
            :movie => {:title => "Movie B", 
            :rating => "R", 
            :description => "this is some description", 
            :release_date => "1001-11-11 10:10:10", 
            :director => "some other director"}
            @testmovie1.reload
            expect(@testmovie1.title).to eq("Movie B")
        end
    end

    describe "delete destory method" do
        before do
        @testmovie1 = Movie.create!({
            :id => 100,
            :title => "Movie A", 
            :rating => "G", 
            :description => "This is a movie description",
            :release_date => "2022-12-04", 
            :director => "Some director"})
        end
        it "should delete the page and redirect" do
            delete :destroy, :id => @testmovie1.id
            expect(response).to redirect_to movies_path
        end
    end


end