MindpinEduSns::Application.routes.draw do
  root :to => 'index#index'
  
  resources :media_files do
    collection do
      post :create_by_edu
    end
  end
end
