# -- 用户认证相关 --
def match_auth_routes
  get  '/login'  => 'account/sessions#new'
  post '/login'  => 'account/sessions#create'
  get  '/logout' => 'account/sessions#destroy'
  
  get  '/signup'        => 'account/signup#form'
  post '/signup_submit' => 'account/signup#form_submit'
end

def match_forgot_password_routes
  namespace(:account) do
    get '/forgot_password'                => 'forgot_password#form' 
    post '/forgot_password/submit'        => 'forgot_password#form_submit'
    get '/reset_password/:pw_code'        => 'forgot_password#reset'
    put 'reset_password_submit/:pw_code'  => 'forgot_password#reset_submit'
  end
end

Mindpin::Application.routes.draw do
  # ---------------- 首页和欢迎页面 ---------
  root :to => 'index#index'
  
  match_auth_routes
  match_forgot_password_routes
end
