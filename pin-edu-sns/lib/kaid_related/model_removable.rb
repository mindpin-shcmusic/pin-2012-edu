require 'active_support/concern'

module ModelRemovable
  extend ActiveSupport::Concern

  included do
    default_scope   where(:is_removed => false)
    scope :removed, where(:is_removed => true)
  end

  module InstanceMethods
    def remove
      self.update_attribute :is_removed, true
    end

    def recover
      self.update_attribute :is_removed, false
    end
  end

end
