require 'singleton'

module MindpinSidebar
  class CurrentContext
    attr_accessor :rules, :nav, :subnav
    include Singleton
  end
end