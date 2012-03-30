MindpinEduSns::Application.routes.draw do
  resources :teachers do
    member do
      get :set_user
      put :do_set_user
    end
  end
  resources :courses do
    member do
      get :select_teacher
      put :set_teacher
    end
  end
  resources :students do
    member do
      get :set_user
      put :do_set_user
    end
  end
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
