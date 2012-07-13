# -- 用户认证相关 --
def match_auth_routes
  get  '/login'  => 'sessions#new'
  post '/login'  => 'sessions#create'
  get  '/logout' => 'sessions#destroy'
  
  get  '/signup'        => 'signup#form'
  post '/signup_submit' => 'signup#form_submit'
end

# -- 设置 --
def match_account_routes
  # 基本信息
  get  "/setting"                     => "setting#base"
  put  "/setting"                     => "setting#base_submit"

  # 头像设置
  get  "/setting/avatar"              => 'setting#avatar'
  post "/setting/avatar_submit_raw"   => 'setting#avatar_submit_raw'
  post "/setting/avatar_submit_crop"  => 'setting#avatar_submit_crop'
end

MindpinEduSns::Application.routes.draw do
  namespace :auth do
    # ---------------- 首页和欢迎页面 ---------
    root :to => 'sessions#new'
    match_auth_routes
    match_account_routes
  end

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
            :only => [:create] do

    collection do
      get :inbox
    end
  end
  
  resources :short_messages do
    member do
      put :read
    end

    collection do
      get :inbox
      get :outbox
    end
  end

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

  resources :courses, :teachers
  resources :notifications do
    collection do
      post :read_all
    end

    member do
      put :read
    end
  end
end
