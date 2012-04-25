MindpinEduSns::Application.routes.draw do

  root :to => 'index#index'
  
  # ------------- 媒体文件
  resources :media_files do
    collection do
      get :new_psu
      post :create_by_edu
      post :encode_complete
      get :lifei_list
    end
    member do
      get :lifei_info
    end
  end
  
  # --- 用户
  resources :users
  
  # --- 闲聊
  get  '/teams/:team_id/statuses'  => 'statuses#index'
  post '/teams/:team_id/statuses'  => 'statuses#create'
  get  '/statuses/:id/repost'      => 'statuses#repost'
  post '/statuses/:id/repost'      => 'statuses#do_repost'
  
  # --- 教学活动
  resources :activities
  
  # --- 待办事项
  resources :todos do
    member do
      put :do_complete
    end
  end
  # --- 作业
  resources :homeworks do
    collection do
      post :create_teacher_attachement
    end
    
    member do
      get 'student/:user_id' => 'homeworks#student'
      get :download_teacher_zip
    end
  end

  resources :student do
    collection do
      post :upload_homework_attachement
      post :upload_homework_attachement_again
    end
  end

end
