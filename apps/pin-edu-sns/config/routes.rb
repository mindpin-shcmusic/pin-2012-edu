MindpinEduSns::Application.routes.draw do
  root :to => 'index#index'
  
  resources :media_files do
    collection do
      post :create_by_edu
    end
  end
  
  get '/teams/:team_id/statuses'     => 'statuses#index'
  post '/teams/:team_id/statuses'    => 'statuses#create'
  get "/statuses/:id/repost"           => "statuses#repost"
  post "/statuses/:id/repost"          => "statuses#do_repost"
end
