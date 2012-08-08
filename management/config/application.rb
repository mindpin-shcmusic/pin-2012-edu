require File.expand_path('../boot', __FILE__)

# require 'action_controller/railtie'
# require 'action_mailer/railtie'
# require 'active_resource/railtie'
# require 'rails/test_unit/railtie'
require 'rails/all'
# 这里目前必须写 rails/all，因为：
# 为了使得 management 能正常启动主工程，management 必须加载和主工程一样的 Gemfile
# 为了使得 Gemfile 中的 awesome_nested_set 能被加载，必须加载 active_record

if defined?(Bundler)
  Bundler.require(:default, :assets, Rails.env)
end

$APP_RELATIVE_ROOT = '/management'

edu_project_path = File.expand_path("../../../",__FILE__)
MINDPIN_MRS_DATA_PATH = `ruby #{edu_project_path}/parse_property.rb MINDPIN_MRS_DATA_PATH`
module MindpinEduSns
  class Application < Rails::Application
    config.logger = ActiveSupport::BufferedLogger.new("#{MINDPIN_MRS_DATA_PATH}/logs/rails-management-#{Rails.env}.log")
    config.encoding = 'utf-8'
    config.filter_parameters += [:password]
    config.assets.enabled = true
    config.assets.version = '1.0'

    config.autoload_paths += Dir["#{Rails.root}/lib/**/"]
    config.time_zone = 'Beijing'
    config.i18n.default_locale = 'zh-CN'

    config.assets.prefix = File.join($APP_RELATIVE_ROOT, 'assets')

    config.dev_tweaks.autoload_rules do
      keep :all

      skip '/favicon.ico'
      skip :assets
      skip :xhr
      keep :forced
    end

  end
end
