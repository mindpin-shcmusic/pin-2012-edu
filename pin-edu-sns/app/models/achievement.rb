class Achievement < ActiveRecord::Base
  belongs_to :user

  module UserMethods
    def self.included(base)
      base.has_one :achievement

      base.send    :include,
                   InstanceMethods
    end

    module InstanceMethods
      def share_rank
        return 0 unless self.achievement
        Achievement.order('share_rate desc').index(self.achievement) + 1
      end
    end
  end
end
