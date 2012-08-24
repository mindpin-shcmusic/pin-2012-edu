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
      nullify_unique_attributes
    end

    def recover
      self.update_attribute :is_removed, false
    end

  private

    def unique_attributes
      self.class.validators.select {|validator|
        validator.instance_of? ActiveRecord::Validations::UniquenessValidator
      }.first.attributes
    end

    def nullify_unique_attributes
      unique_attributes.each do |attribute|
        self.update_attribute attribute, nil
      end

    end

  end

end
