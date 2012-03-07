MindpinEduSns::Application.routes.draw do
  resources :teachers
  resources :courses do
    member do
      get :select_teacher
      put :set_teacher
    end
  end
  resources :students
  resources :teams do
    member do
      get :select_teacher
      put :set_teacher
      get :select_students
      put :set_students
    end
  end
  
  resources :categories
  
  root :to=>"index#index"
end
