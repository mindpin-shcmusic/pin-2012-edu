require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require(:default, :assets, Rails.env)
end

edu_project_path = File.expand_path("../../../",__FILE__)

MINDPIN_MRS_DATA_PATH = `ruby #{edu_project_path}/parse_property.rb MINDPIN_MRS_DATA_PATH`
module MindpinEduSns
  class Application < Rails::Application
    config.logger = ActiveSupport::BufferedLogger.new("/#{MINDPIN_MRS_DATA_PATH}/logs/rails-edu-sns-#{Rails.env}.log")
    # 当前工程的lib
    config.autoload_paths += Dir["#{Rails.root}/lib/**/"]

    # 当前工程的middleware
    config.autoload_paths += ["#{Rails.root}/app/middleware/"]

    # 时区，国际化
    config.time_zone = 'UTC'
    config.i18n.default_locale = :cn
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.assets.enabled = true
    config.assets.version = '1.0'

    require 'digest/sha1'
    require 'will_paginate/array'
    
    require File.join(Rails.root, 'lib/mindpin_global_methods.rb')
    
    # --- 加载 mindpin_logic 配置
    require File.join(Rails.root, 'lib/mindpin_logic_rule.rb')
    ActiveRecord::Base.send :include, MindpinLogicRule
    # --- 声明邮件服务配置
    ActionMailer::Base.smtp_settings = {
      :address        => "mail.mindpin.com",
      :domain         => "mindpin.com",
      :authentication => :plain,
      :user_name      => "mindpin",
      :password       => "m1ndp1ngoodmail"
    }

  end
end


def randstr(length=8)
  base = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  size = base.size
  re = '' << base[rand(size-10)]
  (length - 1).times {
    re << base[rand(size)]
  }
  re
end

# 获取一个随机的文件名
def get_randstr_filename(uploaded_filename)
  ext_name = File.extname(uploaded_filename)

  return "#{randstr}#{ext_name.blank? ? "" : ext_name }".strip
end

def file_content_type(file_name)
  MIME::Types.type_for(file_name).first.content_type
rescue
  ext = file_name.split(".")[-1]
  case ext
  when 'rmvb'
    'application/vnd.rn-realmedia'
  else
    'application/octet-stream'
  end
end

