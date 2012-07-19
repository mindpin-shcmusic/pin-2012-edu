class Achievement < ActiveRecord::Base
  belongs_to :user

  module UserMethods
    def self.included(base)
      base.has_one :achievement
    end
  end
end