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

  # 设置密码
  get '/setting/password'             => "setting#password"
  put '/setting/password'             => "setting#password_submit"

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
    get '/search' => 'search#index'
    get '/search/:kind' => 'search#show'

    get '/setting/password'             => "setting#password"
    put '/setting/password'             => "setting#password_submit"


    # 管理员多级目录
    resources :upload_document_dirs do
      collection do
        post :create_folder
      end
    end


    resources :teachers do
      collection do
        get :import_from_csv_page
        post :import_from_csv
      end
      member do
        get :password
        put :password_submit
        get 'course/:course_id', :action => 'course_students'
      end
    end

    resources :students do
      collection do
        get :import_from_csv_page
        post :import_from_csv
      end
      member do
        get :password
        put :password_submit
      end
    end

    resources :courses do
      member do
        get  :add_teacher_page
        put  :add_teacher
        get  :select_students
        put  :set_students
        get  :select_cover_page
        post :select_cover
      end
      collection do
        get  :import_from_csv_page
        post :import_from_csv
      end
      resources :course_resources, :shallow => true
    end
    resources :teams do
      member do
        get  :select_students
        put  :set_students
      end
      collection do
        get  :import_from_csv_page
        post :import_from_csv
      end
    end
    
    resources :categories do
      collection do
        get :import_from_yaml_page
        post :import_from_yaml
      end
    end

    resources :course_teachers do
      member do
        get :select_students_page
        put :select_students
        get :edit_time_expression
        get :show_time_expression
        put :update_time_expression
        put :update_location
      end
    end

    resources :teaching_plans do
      collection do
        get :import_from_csv_page
      end
    end

    resources :course_surveys do
      collection do
        get :show_courses_by_semester
        get :show_teachers_by_course
      end
    end

    resources :mentor_notes

    resources :mentor_courses

    
    resources :announcements
    
    root :to=>"index#index"
  end
  ###
  # ----------------------------------------------------------------


  root :to => 'index#index'
  # 工作台
  get '/dashboard' => 'index#dashboard'
  # 搜索
  get '/search' => 'search#index'
  get '/search/:kind' => 'search#show'
  post '/batch_destroy' => 'index#batch_destroy'

  # --- 用户
  resources :users

  resources :teachers

  resources :students

  # --- 老师问答
  resources :questions, :shallow => true do
    resources :answers do
      collection do
        get :received
      end
    end
  end

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
  resources :course_surveys, :shallow => true do
    resources :course_survey_records
  end

  resources :mentor_students


  resources :courses do
    collection do
      get :curriculum
      get :next_for_student
      get :next_for_teacher
    end
    resources :course_resources, :shallow => true
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
  post '/kindeditor_upload' => 'file_entities#kindeditor_upload'
  get  '/download/:download_id' => 'file_entities#download'
  post   '/file_entities/:id/re_encode'  => 'file_entities#re_encode'

  get '/media_resources/lazyload_sub_dynatree' => 'media_resources#lazyload_sub_dynatree'
  get '/media_resources/reload_dynatree'       => 'media_resources#reload_dynatree'
  put '/media_resources/move' => 'media_resources#move'

  resources :media_shares

  get '/media_shares/users/:user_id'       => 'media_shares#share'
  get '/media_shares/users/:user_id/*path' => 'media_shares#share'



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

  resources :announcements do

    member do
      put :announce
    end
  end

  resources :score_lists do
    collection do
      get :mine
      get :course_candidates
    end
  end

end
