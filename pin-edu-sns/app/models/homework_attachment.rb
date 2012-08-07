class HomeworkAttachment < ActiveRecord::Base
  belongs_to :file_entity
  belongs_to :creator,
             :class_name => 'User',
             :foreign_key => 'creator_id'

  validates :name, :creator, :file_entity, :presence => true

  def attach
    self.file_entity.attach
  end

  module UserMethods
    def self.included(base)
      base.has_many :homework_attachments,
                    :foreign_key => 'creator_id'
    end
  end

  module OwnerMethods
    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def homework_attachments
        self.user.homework_attachments
      end
    end
  end
end
