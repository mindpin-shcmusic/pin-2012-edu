require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require(:default, :assets, Rails.env)
end

module MindpinEduSns
  class Application < Rails::Application
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
