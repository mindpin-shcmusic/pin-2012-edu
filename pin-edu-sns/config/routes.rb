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
  get  '/setting/temp_avatar'         => 'setting#temp_avatar'
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
        get :import_from_csv_page
        post :import_from_csv
      end
    end
    resources :students do
      collection do
        get :search
        get :import_from_csv_page
        post :import_from_csv
      end
    end

    resources :courses do
      member do
        get  :select_students
        put  :set_students
        get  :upload_image_page
        post :upload_image
        delete :delete_image
        get  :upload_video_page
        post :upload_video
        delete :delete_video
        get  :select_cover_page
        post :select_cover
      end
      collection do
        get  :search
        get  :import_from_csv_page
        post :import_from_csv
      end
    end
    resources :teams do
      member do
        get  :select_students
        put  :set_students
      end
      collection do
        get  :search
        get  :import_from_csv_page
        post :import_from_csv
      end
    end
    
    resources :categories do
      collection do
        get :search
        get :import_from_yaml_page
        post :import_from_yaml
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
      post :create_student_upload
    end
    
    member do
      get :download_teacher_zip
    end
  end

  resources :homework_assigns, :only => [:show] do
    member do
      get :download_student_zip
      put :set_finished
      put :set_submitted
    end
  end

  delete 'homeworks/teacher_attachment/:id/destroy' => 'homeworks#destroy_teacher_attachment'
  delete 'homeworks/requirement/:id/destroy' => 'homeworks#destroy_requirement'

  resources :homeworks, :student

  resources :teachers

  # 查看当前用户参与或负责的课程
  resources :courses do
    collection do
      get :mine
    end

    resources :course_images, :only => [:create, :destroy], :shallow => true
    resources :course_videos, :only => [:create, :destroy], :shallow => true
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

  get  'file_show/*path' => 'media_resources#file_show', :format => false

  post '/upload' => 'file_entities#upload'
  get  '/download/:download_id' => 'file_entities#download'
  post   '/file_entities/:id/re_encode'  => 'file_entities#re_encode'

  get '/media_resources/lazyload_sub_dynatree' => 'media_resources#lazyload_sub_dynatree'
  get '/media_resources/reload_dynatree'       => 'media_resources#reload_dynatree'
  put '/media_resources/move' => 'media_resources#move'

  resources :media_shares do
    collection do
      get :search
    end
  end

  get '/media_shares/users/:user_id'       => 'media_shares#share'
  get '/media_shares/users/:user_id/*path' => 'media_shares#share'

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
  get '/check_tip_messages' => 'index#check_tip_messages'

  get    '/tags/:tag_name'             => 'tags#show'
  get    '/tags/:tag_name/mine'        => 'tags#show_mine'
  get    '/tags/:tag_name/public'      => 'tags#show_public'
  get    '/tags/:tag_name/shared'      => 'tags#show_shared'

  resources :categories do
    member do
      get :lazyload_sub_dynatree
    end
  end
end
