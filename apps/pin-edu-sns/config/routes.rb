MindpinEduSns::Application.routes.draw do
  resources :media_files do
    collection do
      post :create_by_edu
    end
  end
end
