require 'rubygems'

# Set up gems listed in the Gemfile.
# 这里必须使用和主工程同样的 Gemfile 否则主工程无法由此管理工程启动
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../pin-edu-sns/Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
