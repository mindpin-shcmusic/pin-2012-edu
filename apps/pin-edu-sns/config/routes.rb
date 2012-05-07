MindpinEduSns::Application.routes.draw do

  root :to => 'index#index'
  
  # ------------- 媒体文件
  resources :media_files do
    collection do
      get  :mine # 我的资源
      get  :new_psu
      post :create_by_edu
      get  :lifei_list
      get  :check_md5
      get  :search
    end
    member do
      get :lifei_info
      post :encode_complete
      post :file_merge_complete
      post :file_copy_complete
      post :edit_description
    end
  end
  
  # --- 用户
  resources :users

  # --- 评论
  resources :comments,
            :only => [:create]
  
  # --- 作业
  resources :homeworks do
    collection do
      post :create_teacher_attachement
    end
    
    member do
      get :download_teacher_zip
    end
  end
  get 'homeworks/:id/:download_teacher_zip' => 'homeworks#download_teacher_zip'
  # 老师查看某一学生作业路由
  get 'homeworks/:homework_id/student/:user_id' => 'homeworks#student'

  resources :homeworks, :student
end
