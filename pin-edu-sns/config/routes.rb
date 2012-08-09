# -*- coding: utf-8 -*-
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

  ###
  namespace :admin do
    resources :teachers do
      collection do
        get :search
      end
    end
    resources :courses do
      member do
        get :select_teacher
        put :set_teacher
      end
      collection do
        get :search
      end
    end
    resources :students do
      collection do
        get :search
      end
    end
    resources :teams do
      member do
        get :select_teacher
        put :set_teacher
        get :select_students
        put :set_students
      end
      collection do
        get :search
        get :import_from_csv_page
        post :import_from_csv
      end
    end
    
    resources :categories do
      collection do
        get :search
      end
    end
    
    root :to=>"index#index"
  end
  ###

  root :to => 'index#index'
  
  # --- 用户
  resources :users

  # ----------------------

  # 所有类型的评论都在这里，不单独定义
  resources :comments do
    collection do
      get 'show_model_comments'
      get 'received' # 我收到的评论
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
      post :create_teacher_attachment
    end
    
    member do
      get :download_teacher_zip
    end
  end
  get 'homeworks/:id/:download_teacher_zip' => 'homeworks#download_teacher_zip'
  # 老师查看某一学生作业路由
  get 'homeworks/:homework_id/student/:user_id' => 'homeworks#student'


  resources :homeworks, :student

  resources :teachers
  resources :courses do
    member do
      get :upload_image_page
      post :upload_image
      get :select_cover_page
      post :select_cover
    end
  end
  resources :notifications do
    collection do
      post :read_all
    end

    member do
      put :read
    end
  end

  # --------------------

  # web
  get    '/file' => 'media_resources#index'
  get    '/file/*path' => 'media_resources#file', :format => false

  put    '/file_put/*path' => 'media_resources#upload_file'
  post   '/file/create_folder' => 'media_resources#create_folder'
  delete '/file/*path' => 'media_resources#destroy'

  get    '/file_attr/*path/edit_tag' => 'media_resources#edit_tag'
  post   '/file_attr/*path/update_tag' => 'media_resources#update_tag'
  post   '/file_attr/*path/re_encode'  => 'media_resources#re_encode'

  get  'file_show/*path' => 'media_resources#file_show', :format => false

  post '/new_upload' => 'slice_temp_files#new_upload'
  post '/upload_blob' => 'slice_temp_files#upload_blob'
  get  '/new_upload_page' => 'slice_temp_files#new_upload_page'

  get '/media_resources/:id' => 'media_resources#show'

  resources :media_shares do
    collection do
      get :mine
      get :search
    end
  end
  get    '/media_shares/user/:id/file/*path' => 'media_shares#share'
  get    '/media_shares/shared_by/:user_id'  => 'media_shares#shared_by'



  # 全文索引
  get    '/file_search' => 'media_resources#search'
  # 结束全文索引

  # api
  get    '/api/file/*path'            => 'media_resources_api#get_file'
  put    '/api/file_put/*path'        => 'media_resources_api#put_file'
  get    '/api/metadata/*path'        => 'media_resources_api#get_metadata'
  get    '/api/delta'                 => 'media_resources_api#get_delta'
  post   '/api/fileops/create_folder' => 'media_resources_api#create_folder'
  delete '/api/fileops/delete'        => 'media_resources_api#delete'

  # 公共资源
  resources :public_resources do
    collection do
      post :share
      put :upload
      get :search
    end
  end

  get '/public_resources/user/:id/file/*path' => 'public_resources#dir'
  get '/public_resources/user/:id/index_file/:file_entity_id' => 'public_resources#index_file'
  put '/public_resources/upload/*path' => 'public_resources#upload'
  get '/user_complete_search' => 'index#user_complete_search'

  get '/tags/:tag_name' => 'tags#show'
end
