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
      get :download_teacher_zip
    end
  end
  get 'homeworks/:id/:download_teacher_zip' => 'homeworks#download_teacher_zip'
  # 老师查看某一学生作业路由
  get 'homeworks/:homework_id/student/:user_id' => 'homeworks#student'

  resources :homeworks, :student
  
  # ------------------- 投票
  resources :votes do
    collection do
      get :byme
      get :has_voted
    end
    
    member do
      get :voted_users
      get :result
      
      get :add_tag
      post :do_add_tag
      delete :remove_tag
    end
    
    resources :comments
  end
  get 'votes/new/:kind' => 'votes#new'
  resources :vote_results
  
  
  # --- 问答
  resources :questions do
    collection do
      get :byme
      get :answered
    end
    
    member do
      get :add_tag
      post :do_add_tag
      delete :remove_tag
    end
    
    resources :question_comments
  end
  
  resources :answers do
    member do
      post :vote_up
      post :vote_down
    end
    
    resources :answer_comments
  end
  
  resources :question_comments, :answer_comments do
    member do
      get :reply
      post :do_reply
    end
  end
  # --- 通知
  resources :notifications
  # --- 短消息
  resources :short_messages do
    collection do
      get 'exchange'
    end
  end
end
