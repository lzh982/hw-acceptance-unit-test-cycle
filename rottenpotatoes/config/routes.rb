Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
  
  get '/movies/:id/similar_directors' => 'movies#similar', :as => 'similar_directors'
end
