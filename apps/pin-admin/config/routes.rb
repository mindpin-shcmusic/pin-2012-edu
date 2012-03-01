MindpinEduSns::Application.routes.draw do
  resources :teachers
  resources :courses do
    member do
      get :select_teacher
      put :set_teacher
    end
  end
  
  root :to=>"index#index"
end
