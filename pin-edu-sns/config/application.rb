# -*- coding: utf-8 -*-
require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require(:default, :assets, Rails.env)
end

EDU_PROJECT_PATH = File.expand_path("../../../",__FILE__)

MINDPIN_MRS_DATA_PATH = `ruby #{EDU_PROJECT_PATH}/parse_property.rb MINDPIN_MRS_DATA_PATH`
module MindpinEduSns
  class Application < Rails::Application
    # 设置 acts-as-taggable-on 的分隔符
    ActsAsTaggableOn.delimiter = [',', ' ', '，']
    if Rails.env != "development"
      config.logger = ActiveSupport::BufferedLogger.new("/#{MINDPIN_MRS_DATA_PATH}/logs/rails-edu-sns-#{Rails.env}.log")
    end
    # 当前工程的lib
    config.autoload_paths += Dir["#{Rails.root}/lib/**/"]

    # 当前工程的middleware
    config.autoload_paths += ["#{Rails.root}/app/middleware/"]

    # 当前工程的 模型
    config.autoload_paths += Dir["#{Rails.root}/app/edu_models/**/"]

    # 时区，国际化
    config.time_zone = 'UTC'
    config.i18n.default_locale = :cn
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.assets.enabled = true
    config.assets.version = '1.0'

    require 'digest/sha1'
    require 'will_paginate/array'
    require 'csv'
    
    require File.join(Rails.root, 'lib/mindpin_global_methods.rb')

    config.dev_tweaks.autoload_rules do
      keep :all

      skip '/favicon.ico'
      skip :assets
      skip :xhr
      keep :forced
    end

    config.action_view.sanitized_allowed_tags = 'table', 'tr', 'td', 'th',
    'thead', 'tbody', 'tfoot', 'h3', 'h4', 'div', 'ul', 'ol', 'li', 'a',
    'code', 'pre', 'p', 'br', 'img', 'cite', 'blockquote', 'b', 'i', 'em',
    'strong', 'span'

    config.action_view.sanitized_allowed_attributes = 'href', 'src'
  end

end

$REDIS_NAMESPACE = 'MindpinAgile'
