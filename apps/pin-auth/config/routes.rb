# -- 用户认证相关 --
def match_auth_routes
  get  '/login'  => 'sessions#new'
  post '/login'  => 'sessions#create'
  get  '/logout' => 'sessions#destroy'
  
  get  '/signup'        => 'signup#form'
  post '/signup_submit' => 'signup#form_submit'
end

MindpinEduSns::Application.routes.draw do
  # ---------------- 首页和欢迎页面 ---------
  root :to => 'index#index'
  match_auth_routes
end
